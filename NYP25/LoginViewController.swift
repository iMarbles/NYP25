//
//  LoginViewController.swift
//  NYP25
//
//  Created by iOS on 22/11/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var usernameTb: UITextField!
    @IBOutlet weak var passwordTb: UITextField!
    @IBOutlet weak var invalidLbl: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        //For quick login
        //usernameTb.text = "admin1"
        //usernameTb.text = "142519G"
        passwordTb.text = "P@ssw0rd"
        
        LoginDM.loginUser(username: usernameTb.text!, password: passwordTb.text!, onComplete: {
            if(GlobalDM.CurrentUser!.userId  == "NIL"){
                self.invalidLbl.isHidden = false
                self.passwordTb.text = ""
            }else{
                //To handle segue
                var viewController : UIViewController
                if(GlobalDM.CurrentUser!.isAdmin == 1){
                    viewController = UIStoryboard(name: "AdminMain", bundle: nil).instantiateViewController(withIdentifier: "AdminTab") as UIViewController
                }else{
                     viewController = UIStoryboard(name: "UserMain", bundle: nil).instantiateViewController(withIdentifier: "UserMain") as UIViewController
                }
                self.present(viewController, animated: false, completion: nil)
            }
        })
    }
}
