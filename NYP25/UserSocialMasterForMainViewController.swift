//
//  UserSocialMasterForMainViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 31/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class UserSocialMasterForMainViewController: UIViewController {

    @IBOutlet weak var listView: UIView!
    var eventNameList : [Event] = []

    @IBAction func goToSecond(sender: AnyObject) {
        tabBarController?.selectedIndex = 4
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UserSocialDM.retrieveEventNames(onComplete: { (nameList) in
            self.eventNameList = nameList
        })
    }
    
    @IBAction func btnUpload(sender: AnyObject) {
        if(eventNameList.count != 0){
            let storyBoard : UIStoryboard = UIStoryboard(name: "UserSocial", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UserSocialSelectImage") as! UserSocialSelectImageViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            var alert = UIAlertView(
                title: nil,
                message: "Sorry, there's no album available currently for upload!",
                delegate: nil,
                cancelButtonTitle: "Ok")
            alert.show()
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "AlbumDetailsCollection" {
//            let a = segue.destination as! UserSocialViewAlbumPhotosCollectionViewController
//            
//            a.eventIdLbl = (eventInfo?.eventId)!
//        }
    }

}
