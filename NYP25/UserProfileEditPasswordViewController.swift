//
//  UserProfileEditPasswordViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 25/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileEditPasswordViewController: UIViewController {

    @IBOutlet var currentPassTxt: UITextField!
    @IBOutlet var newPassTxt: UITextField!
    @IBOutlet var retypePassTxt: UITextField!

    @IBAction func btnSave(sender: UIButton){
        let currentPass = currentPassTxt.text
        let newPass = newPassTxt.text
        let retypePass = retypePassTxt.text
        
        if(currentPass == newPass){
            print("same")
        }else{
            if(newPass == retypePass){
                print("correct")
                UserProfileDM.updatePassword(currentUser: (GlobalDM.CurrentUser?.userId)!, password: newPass!)
            }else{
                print("doesn't match")
            }
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
