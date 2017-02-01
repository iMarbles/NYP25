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
    
    var newLbl : String = ""
    var pathLbl : String = ""
    var newSocialLbl : String = ""
    
    //Edited by Amabel
    var socialImg : Social?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Edited by Amabel
        photoIdLbl.text = socialImg?.eventId
        pathIdLbl.text = socialImg?.photoUrl
        socialIdLbl.text = socialImg?.socialId
        
        UserSocialProfileMasterViewController.loadImage(imageView: self.photoImage, url: (socialImg?.photoUrl)!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionDelete(sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "You sure you wanna delete this post?", message: nil, preferredStyle: .alert)
        
        let destroyAction = UIAlertAction(title: "Delete Post", style: .destructive) { action in
            //            print(action)
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
        if segue.identifier == "ProfileComments" {
            let a = segue.destination as! UserProfileCommentsForOwnPhotosTableViewController
            
//            a.newSocialLbl = (socialImg?.socialId)!
            a.newSocialLbl = (socialImg?.socialId)!
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
