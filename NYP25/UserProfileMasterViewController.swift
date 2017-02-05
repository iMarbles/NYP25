
//  UserProfileMasterViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 20/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileMasterViewController: UIViewController {
    
    @IBOutlet weak var selfPhotoView : UIView?
    
    @IBOutlet weak var badgeCountBtn : UIButton?
    
    @IBOutlet weak var profilePhotoView : UIImageView?
    @IBOutlet weak var selectedBadge : UIImageView?
    
    @IBOutlet weak var currentPoints : UILabel?
    @IBOutlet weak var bioLbl : UILabel?
    @IBOutlet weak var schoolLbl : UILabel?
    
    var studentList : [Student] = []
    var badgeList : [Badge] = []
    var profileGallery : [Badge] = []

    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.profilePhotoView?.image = UIImage(named: "loading-512")
        self.selectedBadge?.image = UIImage(named: "loading-512")
        
//        UserProfileDM.retrieveAllUsersBadge(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: {(badges) in
//            self.profileGallery = badges
//            self.collectionView?.reloadData()
//            
//            self.noItemsLbl.isHidden = true
//            
//            self.profileGallery.count
//        })
        
        UserProfileDM.retrieveUsersInfo(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: { (user) in
            self.title = user.username
            self.bioLbl?.text = user.bio
            self.schoolLbl?.text = user.school
            self.currentPoints?.text = String(describing: user.points)
            if(user.displayPhotoUrl != nil){
                UserSocialProfileMasterViewController.loadImage(imageView: self.profilePhotoView!, url: user.displayPhotoUrl!)
                UserSocialProfileMasterViewController.circleFramePhoto(image: self.profilePhotoView!)
            }
        })

        
        //for badge retrieval as array
        UserProfileDM.retrieveAllStudentInfo(onComplete: {(studList) in
            self.studentList = studList
            
            for a in self.studentList{
                if(a.userId == (GlobalDM.CurrentUser?.userId)!){
//                    if((a.badges?.count)! != 0){
                        for b in a.badges!{
                            if(b.isDisplay == 1){
                                self.badgeList.append(b)
                                UserSocialProfileMasterViewController.loadImage(
                                    imageView: self.selectedBadge!,
                                    url: b.icon)
                                UserSocialProfileMasterViewController.roundedEdgePhoto(image: self.selectedBadge!)
                            }
                        }
//                    }else{
//                        self.selectedBadge?.image = UIImage(named: "Delete-50")
//                    }
                    print("count - \(a.badges?.count)")
                    
                    self.badgeCountBtn?.setTitle("\((a.badges?.count)!)", for: .normal)
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
