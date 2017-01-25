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

    @IBOutlet var hintMessage : UITextView!
    
    @IBOutlet var savePassword : UIBarButtonItem?

    @IBAction func savePassword(sender: UIButton){
        UserProfileDM.updatePassword(currentUser: (GlobalDM.CurrentUser?.userId)!, password: newPassTxt.text!)
        
        currentPassTxt.isEnabled = false
        newPassTxt.isEnabled = false
        retypePassTxt.isEnabled = false
        
        let alertController = UIAlertController(title: "Password Changed Successfully", message: nil, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            GlobalDM.CurrentUser = User()
            let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginNav") as UIViewController
            self.present(viewController, animated: false, completion: nil)
        }
        alertController.addAction(OKAction)
        
        self.present(alertController, animated: true) {}
    }
    
    @IBAction func btnVerify(sender: UIButton){
        var hint = ""
        
        UserProfileDM.getUserCurrentPassword(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: { (c) in
            let shaData = self.sha256(self.currentPassTxt.text!)
            let shaHex =  shaData!.map { String(format: "%02hhx", $0) }.joined()
            
            //check firebase password and user input if equals
            if (c.password == shaHex){
                self.currentPassTxt.isEnabled = false
                
                //enable new password field if correct
                self.newPassTxt.isEnabled = true
                self.newPassTxt.isSecureTextEntry = true

                //enable retype password field if correct
                self.retypePassTxt.isEnabled = true
                self.retypePassTxt.isSecureTextEntry = true
                
                hint += "Successful : Current Password Verified\n\n"

                //encrypt user new password input
                let shaDataNewPass = self.sha256(self.newPassTxt.text!)
                let shaHexNewPass =  shaDataNewPass!.map { String(format: "%02hhx", $0) }.joined()
                
                //New Password and Retype Password Fields
                let newPass = self.newPassTxt.text
                let retypePass = self.retypePassTxt.text
                
                //check current password and user new password input if equals
                if(shaHex != shaHexNewPass){
                    if(newPass?.isEmpty != true){
                        
                        hint += "Successful : New Password Verified\n\n"
                        
                        if(retypePass?.isEmpty != true){
                            if(retypePass == newPass){
                                hint += "Successful : New Password Matched\n\n"
                                
                                self.currentPassTxt.isEnabled = false
//                                self.newPassTxt.isEnabled = false
//                                self.retypePassTxt.isEnabled = false
                                
                                sender.isEnabled = false
                                
                                self.savePassword?.isEnabled = true
                            }else{
                                hint += "Error : New Password Unmatched\n\n"
                            }
                        }
                    }
                }else{
                    hint += "Error : You can't use the same password as current one!!\n\n"
                }
            }else{
                hint += "Error : Password entered does not match with existing password!\n\n"
            }

            self.hintMessage?.text = hint
        })
    }
    
    
    //SHA256
    func sha256(_ string: String) -> Data? {
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil; }
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
