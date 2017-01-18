//
//  UserSocialProfilePageViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 13/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialProfilePageViewController: UIViewController {
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
