//
//  UserSocialMainGridCollectionViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 16/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialMainGridCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var social : Social?
    var socialPhotos : [Social] = []
    
    var eventIdLbl : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserSocialDM.retrieveEventPhotos(onComplete: { (photos) in
            self.socialPhotos = photos
            self.collectionView?.reloadData()
            
            if(self.socialPhotos.count == 0){
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
        return socialPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UserSocialGalleryCollectionViewCell
        
        UserSocialProfileMasterViewController.loadImage(imageView: cell.eventImage, url: socialPhotos[(indexPath as IndexPath).row].photoUrl!)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        eventIdLbl = socialPhotos[(indexPath as IndexPath).row].eventId

        print("didSelectItemAt - \(socialPhotos[(indexPath as IndexPath).row].eventId)")
        print("eventIdLbl - \(eventIdLbl)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SocialPhotoDetails" {
            let a = segue.destination as! UserSocialPhotoDetailsViewController
            a.newLbl = eventIdLbl
        }
    }
}
