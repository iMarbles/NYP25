//
//  UserProfileViewBadgesCollectionViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 21/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"

class UserProfileViewBadgesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var profileGallery : [Badge] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        UserSocialDM.retrieveEventPhotos(onComplete: { (photos) in
//            self.profileGallery = photos
//            self.collectionView?.reloadData()
//            
//            if(self.profileGallery.count == 0){
//                let alert = UIAlertView(title: "",
//                                        message: "No Photos Available Currently",
//                                        delegate: nil,
//                                        cancelButtonTitle: "Ok")
//                alert.show()
//                
//            }
//        })
        
        UserProfileDM.retrieveAllUsersBadge(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: {(badges) in
            self.profileGallery = badges
            self.collectionView?.reloadData()
            
            if(self.profileGallery.count == 0){
                let alert = UIAlertView(title: "",
                                        message: "No Photos Available Currently",
                                        delegate: nil,
                                        cancelButtonTitle: "Ok")
                alert.show()
                
            }
        })
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileGallery.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "badgeCell", for: indexPath) as! UserProfileViewBadgesCollectionViewCell
        
        loadGallery(imageView: cell.badgePhotos, url: profileGallery[(indexPath as IndexPath).row].icon)
        return cell
    }
    
    func loadGallery(imageView: UIImageView, url: String)
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
