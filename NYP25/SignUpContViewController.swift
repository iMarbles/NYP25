//
//  SignUpContViewController.swift
//  NYP25
//
//  Created by Kenneth on 2/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class SignUpContViewController: UIViewController {
    @IBOutlet weak var testLabel: UILabel!
    
    var fullName : String?
    var adminNumber : String?
    var school : String?
    var username : String?
    var password : String?
    
    var bio : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        testLabel.text = "Segue Test : \(fullName!)"
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
