 //
 //  SignupViewController.swift
 //  NYP25
 //
 //  Created by Kenneth on 22/1/17.
 //  Copyright © 2017 NYP. All rights reserved.
 //
 import UIKit
 
 class SignupViewController: UIViewController {
    var bioSelected = false;
    @IBOutlet weak var fnLabel: UILabel!
    @IBOutlet weak var fnTf: UITextField!
    @IBOutlet weak var admLabel: UILabel!
    @IBOutlet weak var admTf: UITextField!
    @IBOutlet weak var schLabel: UILabel!
    @IBOutlet weak var schTf: UITextField!
    
    
    @IBOutlet weak var unLabel: UILabel!
    @IBOutlet weak var unTf: UITextField!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var bioTv: UITextView!
    @IBOutlet weak var pwLabel: UILabel!
    @IBOutlet weak var pwTf: UITextField!
    @IBOutlet weak var cpwLabel: UILabel!
    @IBOutlet weak var cpwTf: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fnTf.becomeFirstResponder();
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func regBtnPressed(_ sender: Any) {
        if (fnTf.text == "" ||
            admTf.text == "" ||
            schTf.text == "" ||
            unTf.text == "" ||
            pwTf.text == "" ||
            cpwTf.text == "") {
            let alertController = UIAlertController(title: "Oops!", message: "Looks like you didn't fill in all the fields.", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        } else if (pwTf.text != cpwTf.text) {
            let alertController = UIAlertController(title: "Oops!", message: "Your passwords do not match.", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            
        }else {
            let alertController = UIAlertController(title: "Nice!", message: "Everything looks good.", preferredStyle: UIAlertControllerStyle.alert)
            
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
            // shit works
            //            RegisterDM.createUser(user : "hello");
            print("======");
            // shit doesnt work
            //            RegisterDM.getUsers(admin: admTf.text!, username: unTf.text!, onComplete: {(Array<Student>) in
            //                
            //            })
        }
    }
 }
