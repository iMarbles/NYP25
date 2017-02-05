//
//  UserProfileViewBadgesCollectionViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 21/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileViewBadgesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var profileGallery : [Badge] = []
    
    var currentBadgeSelected : String = ""
    
    @IBOutlet weak var noItemsLbl : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserProfileDM.retrieveAllUsersBadge(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: {(badges) in
            self.profileGallery = badges
            self.collectionView?.reloadData()
            
            self.noItemsLbl.isHidden = true
            
            if(self.profileGallery.count == 0){
                self.noItemsLbl.isHidden = false
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
        
        cell.badgePhotos.image = UIImage(named: "loading-512")
        
        UserSocialProfileMasterViewController.loadImage(imageView: cell.badgePhotos, url: profileGallery[(indexPath as IndexPath).row].icon)
        
        let p = profileGallery[(indexPath as IndexPath).row]
        
        if(p.isDisplay == 0){
            cell.badgeCheck?.isHidden = true
        }else{
            cell.badgeCheck?.isHidden = false
            currentBadgeSelected = profileGallery[(indexPath as IndexPath).row].badgeId
            print("currentBadgeSelected - \(currentBadgeSelected)")
        }
        
        return cell
    }
}
