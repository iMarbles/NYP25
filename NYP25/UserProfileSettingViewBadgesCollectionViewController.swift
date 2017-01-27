//
//  UserProfileSettingViewBadgesCollectionViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 27/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileSettingViewBadgesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var profileGallery : [Badge] = []
    
    var currentBadgeSelected : String = ""
    var newBadgeSelected : String = ""
    
    @IBOutlet var btnUpdateSelectedBadge : UIBarButtonItem?

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "badgeCell", for: indexPath) as! UserProfileSettingViewBadgesCollectionViewCell
        
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cell = collectionView.cellForItem(at: indexPath as IndexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.red.cgColor
        
//        print("indexPath - \(profileGallery[(indexPath as IndexPath).row])")
        
        newBadgeSelected = profileGallery[(indexPath as IndexPath).row].badgeId
        print("newBadgeSelected - \(newBadgeSelected)")
        
        btnUpdateSelectedBadge?.isEnabled = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        var cell = collectionView.cellForItem(at: indexPath as IndexPath)
        cell?.layer.borderWidth = 2.0
        cell?.layer.borderColor = UIColor.clear.cgColor
    }

    @IBAction func btnUpdateSelectedBadge(sender: UIButton){
        UserProfileDM.updateCurrentSelectedBadge(badgeId: currentBadgeSelected, userId: (GlobalDM.CurrentUser?.userId)!)
        
        UserProfileDM.updateNewSelectedBadge(badgeId: newBadgeSelected, userId: (GlobalDM.CurrentUser?.userId)!)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}
