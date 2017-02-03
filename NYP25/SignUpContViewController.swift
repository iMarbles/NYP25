//
//  SignUpContViewController.swift
//  NYP25
//
//  Created by Kenneth on 2/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class SignUpContViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {
//    @IBOutlet weak var testLabel: UILabel!
    @IBOutlet weak var uploadBtn: UIButton!
    @IBOutlet weak var uploadImg: UIImageView!
    
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
    
    @IBAction func btnUploadPicTriggered(sender : AnyObject){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
//        isEventImage = false
        
        self.present(picker, animated: true)
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
