
//  UserProfileMasterViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 20/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileMasterViewController: UIViewController {
    
    @IBOutlet weak var badgesView : UIView?
    @IBOutlet weak var selfPhotoView : UIView?
    @IBOutlet weak var likedPhotosView : UIView?
    
    @IBOutlet weak var profilePhotoView : UIImageView?
    
    @IBOutlet weak var currentPoints : UILabel?
    @IBOutlet weak var selectedBadge : UIImageView?
    
    var profileGallery : [Badge] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserSocialProfileMasterViewController.roundedEdgePhoto(image: selectedBadge!)
        UserSocialProfileMasterViewController.circleFramePhoto(image: profilePhotoView!)
        
        badgesView?.isHidden = false
        selfPhotoView?.isHidden = true
        likedPhotosView?.isHidden = true
        
        UserProfileDM.retrieveUsersInfo(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: { (user) in
            self.title = user.username
            self.currentPoints?.text = String(describing: user.points)
            UserSocialProfileMasterViewController.loadImage(imageView: self.profilePhotoView!, url: user.displayPhotoUrl!)
        })

//        UserProfileDM.retrieveUsersDisplayBadge(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: { (u) in
//            self.profileGallery = u
//            UserSocialProfileMasterViewController.loadImage(imageView: self.selectedBadge!, url: u[0].icon)
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnSelfPhoto(sender: UIButton){
        badgesView?.isHidden = true
        selfPhotoView?.isHidden = false
        likedPhotosView?.isHidden = true
    }
    
    @IBAction func btnLikedPhotos(sender: UIButton){
        badgesView?.isHidden = true
        selfPhotoView?.isHidden = true
        likedPhotosView?.isHidden = false
    }
    
    @IBAction func btnBadges(sender: UIButton){
        badgesView?.isHidden = false
        selfPhotoView?.isHidden = true
        likedPhotosView?.isHidden = true
    }
    
    @IBAction func btnLogout(_ sender : AnyObject){
        GlobalDM.CurrentUser = User()
        let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginNav") as UIViewController
        self.present(viewController, animated: false, completion: nil)
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
