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
//    @IBOutlet var btnSave: UIButton!
    
//    var social : Social
    var socialImg : Social? = nil

    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        socialImg = Social()
//        btnSave.isHidden = true;
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
            noCamera()
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
    @IBOutlet weak var txtTesting: UITextField!
    
    @IBAction func btnSave() {
        var imageData : NSData?
        imageData = UIImageJPEGRepresentation(imageView.image!, 0.6)! as NSData
//        var compressedJPGImage = UIImage(data: imageData! as Data)

        
        socialImg?.caption = txtTesting.text

//        UserSocialDM.uploadEventImage(eventId: social.eventId, socialPhotos: imageData! as NSData)
//        UserSocialDM.createPost(social: social!, socialPhotos: imageData! as NSData)
        if socialImg != nil{
            UserSocialDM.createPost(social: socialImg!, socialPhotos: imageData)
        }

//        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        
//        var alert = UIAlertView(title: "Wow",
//                                message: "Your image has been saved to Photo Library!",
//                                delegate: nil,
//                                cancelButtonTitle: "Ok")
//        alert.show()
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [String : Any]!) {
        
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        
        self.dismiss(animated: true, completion: nil);
        
//        btnSave.isHidden = false;
    }
    
    func noCamera(){
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
