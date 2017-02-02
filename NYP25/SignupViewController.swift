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
        if !(schTf.text == "") {
            schTf.text = schTf.text?.uppercased()
        }
        
        if (fnTf.text == "" ||
            admTf.text == "" ||
            unTf.text == "" ||
            pwTf.text == "" ||
            cpwTf.text == "") {
          
            showAlert(title: "Oops!", message: "Looks like you didn't fill in all the fields.")
        } else if (pwTf.text != cpwTf.text) {
            showAlert(title: "Oops!", message: "Your passwords do not match.")
        } else if !(schTf.text == "SIT" || schTf.text == "SIDM" || schTf.text == "SDN" || schTf.text == "SBM" || schTf.text == "SCL" || schTf.text == "SEG") {
            showAlert(title: "Oops!", message: "You have entered an invalid school!")
        } else {
            print("======");
    
    
            admTf.text = admTf.text?.uppercased()
            unTf.text = unTf.text?.lowercased()
            RegisterDM.getUsers(admin: admTf.text!, username: unTf.text!, onComplete: {(sList) in
                var idmatch : Bool = false
                var usermatch : Bool = false
                for s in sList {
                    if(s.userId == self.admTf.text) {
                        idmatch = true;
                    } else if(s.username == self.unTf.text) {
                        usermatch = true;
                    }
                }
                
                if idmatch == true {
                    self.showAlert(title: "Oops!", message: "Your admin number has already been registered.")
                } else if usermatch == true {
                    self.showAlert(title: "Oops!", message: "Your username has already been taken.")
                } else {
                    
                }
            })

                                }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewEventDetails"{
//            let dest = segue.destination as! UserEventDetailsViewController
//            dest.event = eventToPass
        }
    }


 }
