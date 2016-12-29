
//
//  AdminEventsMasterDetailViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 28/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class AdminEventsMasterDetailViewController: UIViewController, UIToolbarDelegate {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var detailContainer : UIView!
    @IBOutlet weak var galleryContainer : UIView!
    @IBOutlet weak var reviewContainer : UIView!
    
    var event : Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.galleryContainer.alpha = 0
        self.reviewContainer.alpha = 0
    }
    
    @IBAction func showComponent(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.detailContainer.alpha = 1
                self.galleryContainer.alpha = 0
                self.reviewContainer.alpha = 0
            })
        }
        else if sender.selectedSegmentIndex == 1 {
            UIView.animate(withDuration: 0.5, animations: {
                self.detailContainer.alpha = 0
                self.galleryContainer.alpha = 1
                self.reviewContainer.alpha = 0
            })
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.detailContainer.alpha = 0
                self.galleryContainer.alpha = 0
                self.reviewContainer.alpha = 1
            })
        }
    }
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.topAttached
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let nextView = segue.identifier
        
        //Edit button
        if nextView == "EditEvent"{
            let editController = segue.destination as! AdminEventsNewViewController
            
            if event != nil {
                editController.event = self.event
            }
        }
    }

}
