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
        
        UserSocialProfileMasterViewController.loadImage(imageView: cell.badgePhotos, url: profileGallery[(indexPath as IndexPath).row].icon)
        
        let p = profileGallery[(indexPath as IndexPath).row]

        if(p.isDisplay == 0){
            cell.badgeCheck?.isHidden = true
        }else{
            cell.badgeCheck?.isHidden = false
        }
        
//        UserProfileDM.retrieveAllBadges(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: { (a) in
//            if(a.isDisplay == 0){
//                cell.badgeCheck.isHidden = true
//            }else{
//                cell.badgeCheck.isHidden = false
//            }
//        })
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cell = collectionView.cellForItem(at: indexPath as IndexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.red.cgColor
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        var cell = collectionView.cellForItem(at: indexPath as IndexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.clear.cgColor
    }
}
