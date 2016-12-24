//
//  AdminEventsNewViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 23/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class AdminEventsNewViewController: UIViewController {
    @IBOutlet weak var descTb : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        descTb.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        descTb.layer.borderWidth = 1.0;
        descTb.layer.cornerRadius = 5.0;
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
