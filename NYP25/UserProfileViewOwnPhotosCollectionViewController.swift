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
        
        UserProfileDM.retrieveAllSocialUserPostedPhotos(onComplete: { (photos) in
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
        
        UserSocialProfileMasterViewController.loadImage(imageView: cell.ownPhotos, url: profileGallery[(indexPath as IndexPath).row].photoUrl!)
        
        return cell
    }
    
    /*
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let p = profileGallery[(indexPath as IndexPath).row]
       
        print(p.socialId)
        
        photoIdLbl = p.eventId
        pathIdLbl = String(describing: p)
        socialIdLbl = p.photoUrl!
            
        print("didSelectItemAt - \(profileGallery[(indexPath as IndexPath).row].eventId)")
        print("indexPath - \(profileGallery[(indexPath as IndexPath).row])")
        
        print("eventIdLbl - \(photoIdLbl)")
        print("pathLbl - \(pathIdLbl)")
        print("socialIdLbl - \(socialIdLbl)")
    }
 */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ownPhotosGallery" {
            let a = segue.destination as! UserProfileDetailsForOwnPhotosViewController
            /*
            a.newLbl = photoIdLbl
            a.pathLbl = pathIdLbl
            a.newSocialLbl = socialIdLbl
             */
            
            //Edited by Amabel
            let cell = sender as? UserProfileViewOwnPhotosCollectionViewCell
            let indexPath = collectionView?.indexPath(for: cell!)

            a.socialImg = profileGallery[(indexPath?.row)!]
        }
    }
}
