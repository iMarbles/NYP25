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
        if(eventNameList.count == 0){
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
