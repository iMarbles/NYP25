//
//  UserSocialMasterForProfileViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 13/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialMasterForProfileViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var likedPhotosView: UIView!
    @IBOutlet weak var selfUploadView: UIView!

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var profilePhotoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserSocialProfileMasterViewController.circleFramePhoto(image: profilePhotoView!)

        UserSocialDM.retrieveAllUserInfo(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: { (user) in
            UserSocialProfileMasterViewController.loadImage(imageView: self.profilePhotoView, url: user.displayPhotoUrl!)
            self.usernameLbl.text = user.username
            self.title =  user.username
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
