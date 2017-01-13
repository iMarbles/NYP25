//
//  UserSocialViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 13/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialViewController: UIViewController {

    var socialList : [Social] = []
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var likedPhotosView: UIView!
    @IBOutlet weak var selfUploadView: UIView!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            likedPhotosView.isHidden = false
            selfUploadView.isHidden = true
            
        case 1:
            likedPhotosView.isHidden = true
            selfUploadView.isHidden = false
            
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserSocialDM.retrieveAllSocial { (listFromDb) in
            self.socialList = listFromDb
//            self.tableView.reloadData()
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
