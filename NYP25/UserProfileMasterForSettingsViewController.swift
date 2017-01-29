//
//  UserProfileMasterForSettingsViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 27/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileMasterForSettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    @IBOutlet var bioField: UITextView?
    @IBOutlet var nameLbl: UILabel?
    @IBOutlet var usernameLbl: UILabel?
    @IBOutlet var passwordLbl: UILabel?
    @IBOutlet var pointsLbl: UILabel?
    @IBOutlet var schLbl: UILabel?
    
    @IBOutlet var btnEditBio : UIButton!
    @IBOutlet var btnSaveBio : UIButton!
    
    @IBOutlet var btnUpdateProfilePhoto : UIButton!
    @IBOutlet var btnChangeProfilePhoto : UIButton!
    
    @IBOutlet weak var profilePhotoView : UIImageView?
    @IBOutlet weak var selectedBadge : UIImageView?
    
    var profileGallery : [Badge] = []
    
    var imagePicker = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserSocialProfileMasterViewController.roundedEdgePhoto(image: selectedBadge!)
        UserSocialProfileMasterViewController.circleFramePhoto(image: profilePhotoView!)

        UserProfileDM.retrieveUsersInfo(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: { (userInfo) in
            self.bioField?.text = userInfo.bio
            self.nameLbl?.text = userInfo.name
            self.usernameLbl?.text = userInfo.username
            self.schLbl?.text = userInfo.school
            UserSocialProfileMasterViewController.loadImage(imageView: self.profilePhotoView!, url: userInfo.displayPhotoUrl!)
        })
        
//        UserProfileDM.retrieveUsersDisplayBadge(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: { (u) in
//            self.profileGallery = u
//            UserSocialProfileMasterViewController.loadImage(imageView: self.selectedBadge!, url: u[0].icon)
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnSaveProfilePhoto(sender: AnyObject){
        
    }
    
    @IBAction func btnChangeProfilePhoto(sender: AnyObject){
        btnUpdateProfilePhoto.isHidden = false
        btnChangeProfilePhoto.isHidden = true
        
        let alertController = UIAlertController(title: nil, message: "Change Profile Photo", preferredStyle: .actionSheet)
        
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
            // ...
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {}
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [String : Any]!) {
        
        profilePhotoView?.contentMode = .scaleAspectFit
        profilePhotoView?.image = image
        
        self.dismiss(animated: true, completion: nil);
        
        self.btnUpdateProfilePhoto.isHidden = true
        self.btnChangeProfilePhoto.isHidden = false
    }
    
    @IBAction func btnSaveBio(sender: AnyObject) {
        bioField?.backgroundColor? = UIColor.clear
        bioField?.isEditable = false
        
        btnEditBio.isHidden = false
        btnSaveBio.isHidden = true
        
        UserProfileDM.updateProfileBio(currentUser: (GlobalDM.CurrentUser?.userId)!, bio: (bioField?.text)!)
    }
    
    @IBAction func btnEditBio(sender: AnyObject) {
        bioField?.isEditable = true
        bioField?.backgroundColor = UIColor.white
        
        
        btnEditBio.isHidden = true
        btnSaveBio.isHidden = false
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
