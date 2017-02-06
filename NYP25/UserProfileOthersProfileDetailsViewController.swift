//
//  UserProfileOthersProfileDetailsViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 6/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileOthersProfileDetailsViewController: UIViewController {
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
    
    var countList : [PhotoLike] = []
    var commentList : [PhotoLike] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoIdLbl.text = socialImg?.eventId
        pathIdLbl.text = socialImg?.photoUrl
        socialIdLbl.text = socialImg?.socialId
        
//        usernameBtn?.setTitle("\((socialImg?.uploaderUsername)!)", for: .normal)
        usernameLbl.text = (socialImg?.uploaderUsername)!
        
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "UserProfileDetailForLikedViewComments" {
//            let a = segue.destination as! UserProfileCommentsForLikedPhotosTableViewController
//            
//            a.photoGallery = (socialImg?.likes)!
//        }else if segue.identifier == "OtherUsersProfile" {
//            let a = segue.destination as! UserProfileOthersProfileViewController
//            
//            a.socialImg = socialImg
//        }
//    }

}
