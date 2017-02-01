//
//  UserProfileViewOwnPhotosCollectionViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 21/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"

class UserProfileViewOwnPhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var profileGallery : [Social] = []

    var photoIdLbl : String = ""
    var pathIdLbl : String = ""
    var socialIdLbl : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserSocialDM.retrieveAllSocial(onComplete: { (photos) in
            self.profileGallery = photos
            self.collectionView?.reloadData()
            
            if(self.profileGallery.count == 0){
                let alert = UIAlertView(title: "",
                                        message: "No Photos Available Currently",
                                        delegate: nil,
                                        cancelButtonTitle: "Ok")
                alert.show()
                
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileGallery.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ownPhotosCell", for: indexPath) as! UserProfileViewOwnPhotosCollectionViewCell
        
        cell.ownPhotos?.image = UIImage(named: "loading-512")

        UserSocialProfileMasterViewController.loadImage(imageView: cell.ownPhotos, url: profileGallery[(indexPath as IndexPath).row].photoUrl!)
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ownPhotosGallery" {
            let a = segue.destination as! UserProfileDetailsForOwnPhotosViewController
            
            let cell = sender as? UserProfileViewOwnPhotosCollectionViewCell
            let indexPath = collectionView?.indexPath(for: cell!)

            a.socialImg = profileGallery[(indexPath?.row)!]
        }
    }
}
