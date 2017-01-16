//
//  UsersSocialMainGridCollectionViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 16/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UsersSocialMainGridCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var social : Social?
    var socialPhotos : [Social] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if(socialPhotos.count!= 0){
            UserSocialDM.retrieveEventPhotos(eventId: (social?.eventId)!, onComplete: { (photos) in
                self.socialPhotos = photos
                self.collectionView?.reloadData()
            })
        }else{
            var alert = UIAlertView(title: "",
                                    message: "No Photos Available Currently",
                                    delegate: nil,
                                    cancelButtonTitle: "Ok")
            alert.show()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return socialPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UserSocialGalleryCollectionViewCell
        
        loadSocialImage(imageView: cell.eventImage, url: socialPhotos[(indexPath as IndexPath).row].photoUrl)
        return cell
    }
    
    func loadSocialImage(imageView: UIImageView, url: String)
    {
        DispatchQueue.global(qos: .background).async
            {
                let nurl = URL(string: url)
                var imageBinary : Data?
                if nurl != nil
                {
                    do
                    {
                        imageBinary = try Data(contentsOf: nurl!)
                    }
                    catch
                    {
                        return
                    }
                }
                
                DispatchQueue.main.async
                    {
                        var img : UIImage?
                        if imageBinary != nil
                        {
                            img = UIImage(data: imageBinary!)
                        }
                        
                        imageView.image = img
                        
                }
                
        }
    }
}
