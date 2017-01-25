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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserSocialDM.retrieveAllSocialUserLikedPhotos(onComplete: { (photos) in
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
}
