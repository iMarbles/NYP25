//
//  UserSocialMasterForMainViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 31/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class UserSocialMasterForMainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var listView: UIView!
    var eventNameList : [Event] = []
    
    var imagePicker = UIImagePickerController()
    var selectedPhotoView : UIImageView!

    
    @IBAction func goToSecond(sender: AnyObject) {
        tabBarController?.selectedIndex = 4
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        UserSocialDM.retrieveEventNames(onComplete: { (nameList) in
            self.eventNameList = nameList
        })
    }
    
//    @IBAction func btnUpload(sender: AnyObject) {
////        if(eventNameList.count != 0){
////            let storyBoard : UIStoryboard = UIStoryboard(name: "UserSocial", bundle:nil)
////            
////            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UserSocialSelectImage") as! UserSocialSelectImageViewController
////            self.navigationController?.pushViewController(nextViewController, animated: true)
////        }else{
////            var alert = UIAlertView(
////                title: nil,
////                message: "Sorry, there's no album available currently for upload!",
////                delegate: nil,
////                cancelButtonTitle: "Ok")
////            alert.show()
////            
////        }
//        
//        if(eventNameList.count != 0){
//            let alertController = UIAlertController(title: nil, message: "Change Profile Photo", preferredStyle: .actionSheet)
//            
//            let openPhotoLibraryAction = UIAlertAction(title: "Choose from Library", style: .destructive) { action in
//                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
//                    self.imagePicker = UIImagePickerController()
//                    
//                    self.imagePicker.delegate = self
//                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
//                    self.imagePicker.allowsEditing = true
//                    
//                    self.present(self.imagePicker, animated: true, completion: nil)
//                }
//            }
//            alertController.addAction(openPhotoLibraryAction)
//            
//            let openCameraAction = UIAlertAction(title: "Take Photo", style: .destructive) { action in
//                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//                    self.imagePicker = UIImagePickerController()
//                    self.imagePicker.delegate = self
//                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
//                    self.imagePicker.allowsEditing = false
//                    self.present(self.imagePicker, animated: true, completion: nil)
//                } else {
//                    let alertVC = UIAlertController(
//                        title: "No Camera",
//                        message: "Sorry, this device has no camera",
//                        preferredStyle: .alert)
//                    let okAction = UIAlertAction(
//                        title: "OK",
//                        style:.default,
//                        handler: nil)
//                    alertVC.addAction(okAction)
//                    self.present(
//                        alertVC,
//                        animated: true,
//                        completion: nil)
//                }
//            }
//            alertController.addAction(openCameraAction)
//            
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
//                print("cancel")
//
//            }
//            alertController.addAction(cancelAction)
//            
//            self.present(alertController, animated: true) {}
//
//        }else{
//            var alert = UIAlertView(
//                title: nil,
//                message: "Sorry, there's no album available currently for upload!",
//                delegate: nil,
//                cancelButtonTitle: "Ok")
//            alert.show()
//            
//        }
//    }
//
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [String : Any]!) {
//        selectedPhotoView?.contentMode = .scaleAspectFill
//        selectedPhotoView?.image = image
//        
//        self.dismiss(animated: true, completion: nil);
//        
//        let controller = self.storyboard?.instantiateViewController(withIdentifier: "UserSocialSelectImage")
//        self.navigationController!.pushViewController(controller!, animated: false)
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "UserSocialSelectImage" {
//            let a = segue.destination as! UserSocialSelectImageViewController
//            a.selectedPhotoView = selectedPhotoView
//        }
//    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////        if segue.identifier == "AlbumDetailsCollection" {
////            let a = segue.destination as! UserSocialViewAlbumPhotosCollectionViewController
////            
////            a.eventIdLbl = (eventInfo?.eventId)!
////        }
//    }

}
