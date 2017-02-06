//
//  UserSocialOthersProfileCollectionViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 6/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialOthersProfileCollectionViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout {
    
    var profileGallery : [Social] = []
    
    var photoIdLbl : String = ""
    var pathIdLbl : String = ""
    var socialIdLbl : String = ""
    @IBOutlet weak var noItemsLbl : UILabel!

    var socialImg : Social?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("userprofile - \((socialImg?.uploader)!)")
        
        UserSocialDM.retrieveAllOtherPhotos(userId : (socialImg?.uploader)! , onComplete: { (photos) in
            self.profileGallery = photos
            self.collectionView?.reloadData()
            
            self.noItemsLbl.isHidden = true
            
            if(self.profileGallery.count == 0){
                self.noItemsLbl.isHidden = false
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileGallery.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "othersUserPhotos", for: indexPath) as! UserSocialOthersProfileCollectionViewCell
        
        cell.ownPhotos?.image = UIImage(named: "loading-512")
        
        UserSocialProfileMasterViewController.loadImage(imageView: cell.ownPhotos, url: profileGallery[(indexPath as IndexPath).row].photoUrl!)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OtherUsersPhotosDetails" {
            let a = segue.destination as! UserSocialOthersProfileDetailsViewController
            
            a.socialImg = socialImg
        }
    }
}
