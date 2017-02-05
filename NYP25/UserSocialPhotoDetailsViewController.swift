//
//  UserSocialPhotoDetailsViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 3/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialPhotoDetailsViewController: UIViewController {

    var socialImg : Social?
    @IBOutlet weak var testLbl : UILabel!
    @IBOutlet weak var commentField : UITextField?
    @IBOutlet weak var commentBtn : UIButton!
    
    var currentUsername : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("socialImg?.socialId - \(socialImg?.socialId)")
        testLbl.text = (socialImg?.socialId)!
        
        UserProfileDM.retrieveUsersInfo(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: {(list) in
            self.currentUsername = "\(list.username)"
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GetListOfComments"{
            let vc = segue.destination as! UserSocialPhotosCommentsTableViewController
            vc.socialImg = socialImg
        }
    }
    
    @IBAction func actionComment(sender: UIButton) {
        UserSocialDM.postComment(socialId: (socialImg?.socialId)!, currentUserId: (GlobalDM.CurrentUser?.userId)!, currentUserName : currentUsername, commentField: (commentField?.text)!)
        
        self.navigationController?.popToRootViewController(animated: true)
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
