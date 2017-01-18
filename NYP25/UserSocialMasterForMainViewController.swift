//
//  UserSocialMasterForMainViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 31/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class UserSocialMasterForMainViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var gridView: UIView!
    @IBOutlet weak var albumView: UIView!
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            listView.isHidden = false
            gridView.isHidden = true
            albumView.isHidden = true
            
        case 1:
            listView.isHidden = true
            gridView.isHidden = false
            albumView.isHidden = true
            
        case 2:
            listView.isHidden = true
            gridView.isHidden = true
            albumView.isHidden = false
            
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
