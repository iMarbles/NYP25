//
//  UserProfileMainSettingsViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 27/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileMainSettingsViewController: UIViewController {

    @IBOutlet var bioLbl: UITextView?
    @IBOutlet var nameLbl: UILabel?
    @IBOutlet var usernameLbl: UILabel?
    @IBOutlet var passwordLbl: UILabel?
    @IBOutlet var pointsLbl: UILabel?
    @IBOutlet var schLbl: UILabel?
    
    @IBOutlet weak var profilePhotoView : UIImageView?
    @IBOutlet weak var selectedBadge : UIImageView?
    
    var profileGallery : [Badge] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserSocialProfileMasterViewController.roundedEdgePhoto(image: selectedBadge!)
        UserSocialProfileMasterViewController.circleFramePhoto(image: profilePhotoView!)

        UserProfileDM.retrieveUsersInfo(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: { (userInfo) in
            self.bioLbl?.text = userInfo.bio
            self.nameLbl?.text = userInfo.name
            self.usernameLbl?.text = userInfo.username
            self.schLbl?.text = userInfo.school
            UserSocialProfileMasterViewController.loadImage(imageView: self.profilePhotoView!, url: userInfo.displayPhotoUrl!)
        })
        
        UserProfileDM.retrieveUsersDisplayBadge(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: { (u) in
            self.profileGallery = u
            UserSocialProfileMasterViewController.loadImage(imageView: self.selectedBadge!, url: u[0].icon)
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
