//
//  UserSocialSelectImageViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 15/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialSelectImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var btnSave: UIButton!
    
    var socialImg : Social? = nil

    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socialImg = Social()
        
        btnSave.isHidden = true;
        
        imageView.layer.masksToBounds = true
    }
    
    @IBAction func openCameraButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alertVC = UIAlertController(
                title: "No Camera",
                message: "Sorry, this device has no camera",
                preferredStyle: .alert)
            let okAction = UIAlertAction(
                title: "OK",
                style:.default,
                handler: nil)
            alertVC.addAction(okAction)
            present(
                alertVC,
                animated: true,
                completion: nil)
        }
    }
    
    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [String : Any]!) {
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        self.dismiss(animated: true, completion: nil);
        
        btnSave.isHidden = false;
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UserSocialUploadImage" {
            let dvc = segue.destination as! UserSocialUploadImageViewController
            dvc.newImage = imageView.image
        }
    }
    
//    func noCamera(){
//        let alertVC = UIAlertController(
//            title: "No Camera",
//            message: "Sorry, this device has no camera",
//            preferredStyle: .alert)
//        let okAction = UIAlertAction(
//            title: "OK",
//            style:.default,
//            handler: nil)
//        alertVC.addAction(okAction)
//        present(
//            alertVC,
//            animated: true,
//            completion: nil)
//    }
}
