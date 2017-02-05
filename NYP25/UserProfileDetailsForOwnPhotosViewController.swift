//
//  UserProfileDetailsForOwnPhotosViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 29/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileDetailsForOwnPhotosViewController: UIViewController {
    @IBOutlet weak var photoIdLbl : UILabel!
    @IBOutlet weak var pathIdLbl : UILabel!
    @IBOutlet weak var socialIdLbl : UILabel!
    @IBOutlet weak var photoImage : UIImageView!
    
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
    
    @IBAction func actionDelete(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "You sure you wanna delete this post?", message: nil, preferredStyle: .alert)
        
        let destroyAction = UIAlertAction(title: "Delete Post", style: .destructive) { action in
            UserProfileDM.deletePhoto(socialId: (self.socialImg?.socialId)!)
            
            self.navigationController?.popToRootViewController(animated: true)
            print("destroy")
        }
        alertController.addAction(destroyAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("cancel")
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {}
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserProfileDetailViewComments" {
            let a = segue.destination as! UserProfileCommentsForOwnPhotosTableViewController
            
            a.photoGallery = (socialImg?.likes)!
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
