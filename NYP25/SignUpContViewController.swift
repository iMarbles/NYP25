//
//  SignUpContViewController.swift
//  NYP25
//
//  Created by Kenneth on 2/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class SignUpContViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate, UITextFieldDelegate {
//    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var uploadImg: UIImageView!
    @IBOutlet weak var bioTv: UITextView!
    @IBOutlet weak var signUpBtn: UIButton!
    
    var fullName : String?
    var adminNumber : String?
    var school : String?
    var username : String?
    var password : String?
    
    var bio : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bioTv.delegate = self
        hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnUploadPicTriggered(sender : AnyObject){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
//        isEventImage = false
        
        self.present(picker, animated: true)
    }
    
    @IBAction func btnSignUpTriggered(sender : AnyObject) {
        if(uploadImg.image == nil) {
            showAlert(title: "Oops", message: "You didn't upload a profile picture.")
        } else if (bioTv.text == "" || bioTv.text == "Say something about yourself...") {
            showAlert(title: "Oops", message: "Please fill in your profile bio.")
        } else {
            let s : Student = Student()
            s.userId = adminNumber!
            s.isAdmin = 0
            s.password = password!//sending as plaintext first, DM should hash
            s.school = school!
            s.name = fullName!
            s.username = username!
            s.points = 0
            s.bio = bioTv.text
            
            var imgData : NSData?
            
            if(uploadImg.image != nil){
                imgData = UIImageJPEGRepresentation(uploadImg.image!, 0.8)! as NSData
            }
            
            
            RegisterDM.createAccount(s: s, dp: imgData)
            showSignInAlert(title: "All Done!", message: "Your account was created!")
        }
        
        
//        var eventData : NSData?
//        if(eventImage.image != nil){
//            eventData = UIImageJPEGRepresentation(eventImage.image!, 0.8)! as NSData
//        }

        
        
        // todo: make this alert let the user decide whether to login or go back to login screen
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        let chosenImage : UIImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        
            self.uploadImg.image = chosenImage
    
        picker.dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
//        testLabel.text = "Segue Test : \(fullName!)"
        uploadImg.layer.borderColor = UIColor.black.cgColor
        uploadImg.layer.borderWidth = 2.0
        bioTv.text = "Say something about yourself..."
        bioTv.textColor = UIColor.lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if bioTv.textColor == UIColor.lightGray {
            bioTv.text = ""
            bioTv.textColor = UIColor.black
        }
    }
    
    override func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if bioTv.text.isEmpty {
            bioTv.text = "Say something about yourself..."
            bioTv.textColor = UIColor.lightGray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func showSignInAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Back to Login", style: UIAlertActionStyle.default,handler: { (alert: UIAlertAction!) in
            var viewController : UIViewController
            viewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "Login") as UIViewController
            self.present(viewController, animated: false, completion: nil)
        }))

        self.present(alertController, animated: true, completion: nil)
        
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
