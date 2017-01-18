//
//  AdminStatisticsMasterViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 31/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class AdminStatisticsMasterViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var dashboardContainer : UIView!
    @IBOutlet weak var statisticsContainer : UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.statisticsContainer.alpha = 0
    }
    
    @IBAction func showComponent(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.dashboardContainer.alpha = 1
                self.statisticsContainer.alpha = 0
            })
            self.navigationItem.title = "Dashboard"
        }
        else {
            UIView.animate(withDuration: 0.5, animations: {
                self.dashboardContainer.alpha = 0
                self.statisticsContainer.alpha = 1
            })
            self.navigationItem.title = "Statistics"
        }
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
        
    }
    

}
