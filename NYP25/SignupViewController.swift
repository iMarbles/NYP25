 //
 //  SignupViewController.swift
 //  NYP25
 //
 //  Created by Kenneth on 22/1/17.
 //  Copyright © 2017 NYP. All rights reserved.
 //
 import UIKit
 
 class SignupViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
        let schools = ["SBM", "SCL", "SDN", "SEG", "SHS", "SIT", "SIDM"]
    var bioSelected = false;
    @IBOutlet weak var fnLabel: UILabel!
    @IBOutlet weak var fnTf: UITextField!
    @IBOutlet weak var admLabel: UILabel!
    @IBOutlet weak var admTf: UITextField!
    @IBOutlet weak var schLabel: UILabel!
    @IBOutlet weak var schTf: UITextField!
    @IBOutlet var schoolPicker: UIPickerView! = UIPickerView()

    
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
        var pickerView = UIPickerView()
        schoolPicker.isHidden = true;
        pickerView.delegate = self
        schTf.text = schools[0]
        schTf.inputView = pickerView
//        schoolPicker.delegate = self
//        schoolPicker.isHidden = true;
//        schTf.text = schools[0]
        fnTf.becomeFirstResponder();

        // Do any additional setup after loading the view.
    }
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return schools.count
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return schools[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        schTf.text = schools[row]
    }
    // returns the # of rows in each component..
//    func pickerView(pickerView: UIPickerView!, numberOfRowsInComponent component: Int) -> Int{
//        return schools.count
//    }
//    
//    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String! {
//        return schools[row]
//    }
//    
//    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
//    {
//        schTf.text = schools[row]
//        schoolPicker.resignFirstResponder()
//        self.view.endEditing(true)
//        schoolPicker.isHidden = true;
//    }
//    
//    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
//        schoolPicker.isHidden = false
//        return false
//    }
    
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
                    // perform segue if everything has been validated
                    self.startSegue()
                }
            })

                                }
    }
    
    func startSegue() {
        performSegue(withIdentifier: "viewSignUp2", sender: self)
    }
    
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSignUp2"{
            let dest = segue.destination as! SignUpContViewController
            dest.fullName = fnTf.text
            dest.adminNumber = admTf.text
            dest.school = schTf.text
            dest.username = unTf.text
            dest.password = pwTf.text // pass in plaintext first
        }
    }


 }
