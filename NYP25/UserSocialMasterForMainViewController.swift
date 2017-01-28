//
//  UserSocialMasterForMainViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 31/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class UserSocialMasterForMainViewController: UIViewController {

//    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var listView: UIView!
//    @IBOutlet weak var gridView: UIView!
    
    /*@IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            listView.isHidden = false
            gridView.isHidden = true
            
        case 1:
            listView.isHidden = true
            gridView.isHidden = false
            
        default:
            break;
        }
    }*/

    @IBAction func goToSecond(sender: AnyObject) {
        tabBarController?.selectedIndex = 4
    }
    
/*    
     @IBAction func gridViewBtn(sender: UIButton){
        listView.isHidden = true
        gridView.isHidden = false
    }
    
    @IBAction func listViewBtn(sender: UIButton){
        listView.isHidden = false
        gridView.isHidden = true
    }
*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        listView.isHidden = false
//        gridView.isHidden = true
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
