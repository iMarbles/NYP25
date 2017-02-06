//
//  UserProfileSettingsViewBadgesCollectionViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 27/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileSettingsViewBadgesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    var profileGallery : [Badge] = []
    
    var currentBadgeSelected : String = ""
    var newBadgeSelected : String = ""
    
    @IBOutlet weak var noItemsLbl : UILabel!
    @IBOutlet var btnUpdateSelectedBadge : UIBarButtonItem?

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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "badgeCell", for: indexPath) as! UserProfileSettingViewBadgesCollectionViewCell
        
        cell.badgePhotos.image = UIImage(named: "loading-512")
        
        UserSocialProfileMasterViewController.loadImage(imageView: cell.badgePhotos, url: profileGallery[(indexPath as IndexPath).row].icon!)
        
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
        UserProfileDM.updateNewSelectedBadge(badgeId: newBadgeSelected, userId: (GlobalDM.CurrentUser?.userId)!)

        UserProfileDM.updateCurrentSelectedBadge(badgeId: currentBadgeSelected, userId: (GlobalDM.CurrentUser?.userId)!)

        self.navigationController?.popToRootViewController(animated: true)
    }
}
