//
//  AdminProfileViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 27/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class AdminProfileViewController: UIViewController {
    @IBOutlet weak var usernameLabel : UILabel!
    @IBOutlet weak var currentPwdTb : UITextField!
    @IBOutlet weak var newPwdTb : UITextField!
    @IBOutlet weak var retypePwdTb : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        usernameLabel.text = GlobalDM.CurrentUser?.userId
        
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logoutButtonPressed(_ sender : AnyObject){
        GlobalDM.CurrentUser = User()
        let viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginNav") as UIViewController
        self.present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func saveButtonPressed(_ sender : AnyObject){
        var msgTitle = ""
        var msg = ""
        
        if validateFields() == ""{
            if LoginDM.checkPassword(password: currentPwdTb.text!){
                //Change password
                LoginDM.changePasswordTo(newPwd: newPwdTb.text!)
                msgTitle = "Password changed"
                msg = "Password has been changed"
                currentPwdTb.text = ""
                newPwdTb.text = ""
                retypePwdTb.text = ""
            }else{
                msgTitle = "Invalid password"
                msg = "Current password is incorrect"
            }
        }else{
            //Alert to show all fields
            msgTitle = "Invalid fields"
            msg = validateFields()
        }
        
        let uiAlert = UIAlertController(title: msgTitle, message: msg, preferredStyle: .alert)
        
        uiAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        
        self.present(uiAlert, animated: true, completion: nil)
    }
    
    func validateFields() -> String{
        var errMsg = ""
        if currentPwdTb.text == ""{
            errMsg += "Please enter current password \n"
        }
        if newPwdTb.text == ""{
            errMsg += "Please enter new password \n"
        }
        if retypePwdTb.text == ""{
            errMsg += "Please retype password \n"
        }
        if newPwdTb.text != "" && retypePwdTb.text != ""{
            if newPwdTb.text != retypePwdTb.text{
                errMsg += "Passwords do not match"
            }
        }
        
        return errMsg
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
