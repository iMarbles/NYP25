
//  UserProfileMasterViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 20/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileMasterViewController: UIViewController {
    
    @IBOutlet weak var selfPhotoView : UIView?
    
    @IBOutlet weak var profilePhotoView : UIImageView?
    
    @IBOutlet weak var currentPoints : UILabel?
    @IBOutlet weak var bioLbl : UILabel?
    @IBOutlet weak var schoolLbl : UILabel?
    @IBOutlet weak var selectedBadge : UIImageView?
    
    var studentList : [Student] = []
    var badgeList : [Badge] = []

    override func viewDidLoad() {
        super.viewDidLoad()
       
        UserProfileDM.retrieveUsersInfo(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: { (user) in
            self.title = user.username
            self.bioLbl?.text = user.bio
            self.schoolLbl?.text = user.school
            self.currentPoints?.text = String(describing: user.points)
            UserSocialProfileMasterViewController.loadImage(imageView: self.profilePhotoView!, url: user.displayPhotoUrl!)
            UserSocialProfileMasterViewController.circleFramePhoto(image: self.profilePhotoView!)
        })

        
        //for badge retrieval as array
        UserProfileDM.retrieveAllStudentInfo(onComplete: {(studList) in
            self.studentList = studList
            
            for a in self.studentList{
                for b in a.badges!{
                    if(b.isDisplay == 1){
                        self.badgeList.append(b)
                        UserSocialProfileMasterViewController.loadImage(
                            imageView: self.selectedBadge!,
                            url: b.icon)
                        UserSocialProfileMasterViewController.roundedEdgePhoto(image: self.selectedBadge!)
                    }
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
