//
//  UserProfileDetailsForLikedPhotosViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 29/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileDetailsForLikedPhotosViewController: UIViewController {
    @IBOutlet weak var photoIdLbl : UILabel!
    @IBOutlet weak var pathIdLbl : UILabel!
    @IBOutlet weak var socialIdLbl : UILabel!
    @IBOutlet weak var photoImage : UIImageView!
    
    @IBOutlet weak var usernameLbl : UILabel!
    @IBOutlet weak var usernameBtn : UIButton?
    @IBOutlet weak var timestampLbl : UILabel!
    
    @IBOutlet weak var countLikesLbl : UILabel!
    @IBOutlet weak var countCommentsLbl : UILabel!
    
    var newLbl : String = ""
    var pathLbl : String = ""
    var newSocialLbl : String = ""
    
    var socialImg : Social?
    var socialInfo : Social?
    
    var countList : [PhotoLike] = []
    var commentList : [PhotoLike] = []
    var socialInfoList : [Social] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoIdLbl.text = socialImg?.eventId
        pathIdLbl.text = socialImg?.photoUrl
        socialIdLbl.text = socialImg?.socialId
        
        
//        usernameLbl.text = socialImg?.uploaderUsername
        usernameBtn?.setTitle("\((socialImg?.uploaderUsername)!)", for: .normal)
        
        timestampLbl.text = GlobalDM.getCommentDateTimeBy(stringDate: (socialImg?.postedDateTime)!)
        
        self.photoImage.image = UIImage(named: "loading-512")
        
        UserSocialDM.retrieveAllPhotosForLikeCount(socialId: (socialImg?.socialId)!, onComplete: {(list) in
            self.countList = list
            self.countLikesLbl.text = String(self.countList.count)
        })
        
        UserSocialDM.retrieveAllPhotosForCommentCount(socialId: (socialImg?.socialId)!, onComplete: {(list) in
            self.commentList = list
            self.countCommentsLbl.text = String(self.commentList.count)
            
        })
        
        UserSocialProfileMasterViewController.loadImage(imageView: self.photoImage, url: (socialImg?.photoUrl)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "UserProfileDetailForLikedViewComments" {
//            let a = segue.destination as! UserProfileCommentsForLikedPhotosTableViewController
//            
//            a.photoGallery = (socialImg?.likes)!
//        }else
//            
            if segue.identifier == "OtherUsersProfile" {
            let a = segue.destination as! UserSocialOthersProfileViewController
            
            a.socialImg = socialImg
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
