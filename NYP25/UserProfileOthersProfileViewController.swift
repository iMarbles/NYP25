//
//  UserProfileOthersProfileViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 6/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileOthersProfileViewController: UIViewController {

    @IBOutlet weak var selfPhotoView : UIView?
    @IBOutlet weak var badgeCountBtn : UIButton?
    @IBOutlet weak var profilePhotoView : UIImageView?
    @IBOutlet weak var selectedBadge : UIImageView?
    @IBOutlet weak var currentPoints : UILabel?
    @IBOutlet weak var bioLbl : UILabel?
    
    var studentList : [Student] = []
    var badgeList : [Badge] = []
    var profileGallery : [Badge] = []

    var socialImg : Social?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("socialImg - \((socialImg?.socialId)!)")
        
        self.profilePhotoView?.image = UIImage(named: "loading-512")
        self.selectedBadge?.image = UIImage(named: "loading-512")
        
        UserProfileDM.retrieveUsersInfo(userId: (socialImg?.uploader)!, onComplete: { (user) in
            self.title = user.username
            self.bioLbl?.text = user.bio
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
                if(a.userId == (self.socialImg?.uploader)!){
                    for b in a.badges!{
                        if(b.isDisplay == 1){
                            self.badgeList.append(b)
                            UserSocialProfileMasterViewController.loadImage(
                                imageView: self.selectedBadge!,
                                url: b.icon)
                            UserSocialProfileMasterViewController.roundedEdgePhoto(image: self.selectedBadge!)
                        }
                    }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "OtherUsersBadge" {
            let a = segue.destination as! UserProfileOtherUsersBadgesCollectionViewController
            
            a.socialImg = socialImg
        }
        else if segue.identifier == "OtherUsersPhotos" {
            let a = segue.destination as! UserProfileOthersProfileCollectionViewController
            
            a.socialImg = socialImg
//
//            let cell = sender as? UserProfileViewLikedPhotosCollectionViewCell
//            let indexPath = collectionView?.indexPath(for: cell!)
//            
//            a.socialImg = profileGallery[(indexPath?.row)!]
//            
        }
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
