//
//  UserSocialSelectImageViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 15/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialSelectImageViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet weak var selectedPhotoView : UIImageView!
    @IBOutlet weak var txtCaption: UITextView!
    @IBOutlet weak var selectedEventId: UILabel!

    @IBOutlet var btnNext: UIBarButtonItem!
    var newImage: UIImage!

    var selectedId = "";
    var imagePicker = UIImagePickerController()

    var socialImg : Social? = nil
//    var likedBy : PhotoLike? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        socialImg = Social()

        print("selectedId - \(selectedId)")     //from previous view controller
        
        UserSocialDM.retrieveEventInfoByID(eventId : selectedId, onComplete: { (list) in
            self.selectedEventId.text = list.name
        })
        
//        selectedEventId.text = selectedId
    }
    
    @IBAction func btnSelect(sender: AnyObject) {
        let alertController = UIAlertController(title: nil, message: "Upload Event Photo", preferredStyle: .actionSheet)
        
        let openPhotoLibraryAction = UIAlertAction(title: "Choose from Library", style: .destructive) { action in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                self.imagePicker = UIImagePickerController()
                
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                self.imagePicker.allowsEditing = true
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        alertController.addAction(openPhotoLibraryAction)
        
        let openCameraAction = UIAlertAction(title: "Take Photo", style: .destructive) { action in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.imagePicker = UIImagePickerController()
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                self.imagePicker.allowsEditing = false
                self.present(self.imagePicker, animated: true, completion: nil)
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
                self.present(
                    alertVC,
                    animated: true,
                    completion: nil)
            }
        }
        alertController.addAction(openCameraAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("cancel")
            
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [String : Any]!) {
        selectedPhotoView?.contentMode = .scaleAspectFill
        selectedPhotoView?.image = image
        
        self.dismiss(animated: true, completion: nil);
        
        txtCaption.isEditable = true
    }
    
    @IBAction func btnSave(sender: AnyObject) {
        var imageData : NSData?
        imageData = UIImageJPEGRepresentation(selectedPhotoView.image!, 0.6)! as NSData
        //        var compressedJPGImage = UIImage(data: imageData! as Data)
        
        //Social
        socialImg?.caption = txtCaption.text
        socialImg?.flagReason = ""
        socialImg?.postedDateTime = txtCaption.text
        socialImg?.uploader = GlobalDM.CurrentUser!.userId
        socialImg?.isFlagged = 0;
    
        socialImg?.eventId = selectedId
        
        
//        //Liked By
//        likedBy?.adminNo = GlobalDM.CurrentUser!.userId
//        likedBy?.isLike = 0;
        
        var hint : String = ""
        UserSocialDM.retrieveAllUserInfo(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: {(u) in
            hint = u.username
            
            if self.socialImg != nil{
                UserSocialDM.createPost(
                    eventId: (GlobalDM.CurrentUser?.userId)!,
                    social: self.socialImg!,
                    socialPhotos: imageData,
                    currentUserId: (GlobalDM.CurrentUser?.userId)!,
                    uploaderUsername: u.username
                )
                
                var alert = UIAlertView(
                    title: nil,
                    message: "Successfully Uploaded",
                    delegate: nil,
                    cancelButtonTitle: "Ok")
                alert.show()
                
                self.navigationController?.popToRootViewController(animated: true)
            }
            
        })
        
        /*        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
         var alert = UIAlertView(
         title: "Wow",
         message: "Your image has been saved to Photo Library!",
         delegate: nil,
         cancelButtonTitle: "Ok")
         alert.show()*/
    }

    
    
//    @IBOutlet var imageView: UIImageView!
//
//    var socialImg : Social? = nil
//    var newImage: UIImage!
//
//    var likedBy : PhotoLike? = nil
//    var comments : PhotoComment? = nil
//    
//    @IBOutlet weak var eventsPickerView: UIPickerView!
//    
//    var eventNames : [Event] = []
//    var valueSelected = "";
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        socialImg = Social()
//        likedBy = PhotoLike()
//        comments = PhotoComment()
//        
//        imageView.image = newImage
//        
//        loadEventNames()
//    }


    
//    @IBOutlet var imageView: UIImageView!
//    @IBOutlet var btnSave: UIButton!
//    
//    var socialImg : Social? = nil
//
//    var imagePicker = UIImagePickerController()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        socialImg = Social()
//        
//        btnSave.isHidden = true;
//        
//        imageView.layer.masksToBounds = true
//    }
//    
//    @IBAction func openCameraButton(sender: AnyObject) {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//            imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
//            imagePicker.allowsEditing = false
//            self.present(imagePicker, animated: true, completion: nil)
//        } else {
//            let alertVC = UIAlertController(
//                title: "No Camera",
//                message: "Sorry, this device has no camera",
//                preferredStyle: .alert)
//            let okAction = UIAlertAction(
//                title: "OK",
//                style:.default,
//                handler: nil)
//            alertVC.addAction(okAction)
//            present(
//                alertVC,
//                animated: true,
//                completion: nil)
//        }
//    }
//    
//    @IBAction func openPhotoLibraryButton(sender: AnyObject) {
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
//            imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
//            imagePicker.allowsEditing = true
//            
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//    }
//    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [String : Any]!) {
//
//        imageView.contentMode = .scaleAspectFit
//        imageView.image = image
//        
//        self.dismiss(animated: true, completion: nil);
//        
//        btnSave.isHidden = false;
//    }
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "UserSocialUploadImage" {
//            let a = segue.destination as! UserSocialUploadImageViewController
//            a.newImage = imageView.image
//        }
//    }
}
