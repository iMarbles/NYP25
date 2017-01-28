//
//  UserProfileViewLikedPhotosCollectionViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 21/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"

class UserProfileViewLikedPhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var profileGallery : [Social] = []
    var likedPhotos : [Social] = []

    var photoIdLbl : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserProfileDM.retrieveAllSocialUserLikedPhotos(onComplete: { (photos) in
            self.profileGallery = photos
            self.collectionView?.reloadData()
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedPhotosCell", for: indexPath) as! UserProfileViewLikedPhotosCollectionViewCell

        
        UserSocialProfileMasterViewController.loadImage(imageView: cell.likedPhotos, url: profileGallery[(indexPath as IndexPath).row].photoUrl!)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        var cell = collectionView.cellForItem(at: indexPath as IndexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.clear.cgColor
    }
    
    /*override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cell = collectionView.cellForItem(at: indexPath as IndexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.red.cgColor

    }*/

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        photoIdLbl = profileGallery[(indexPath as IndexPath).row].eventId
        
        print("didSelectItemAt - \(profileGallery[(indexPath as IndexPath).row].eventId)")
        print("eventIdLbl - \(photoIdLbl)")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "likedPhotosGallery" {
            let a = segue.destination as! UserProfileLikedPhotosDetailsViewController
            a.newLbl = photoIdLbl
        }
    }
}
