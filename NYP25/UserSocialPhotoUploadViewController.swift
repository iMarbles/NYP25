//
//  UserSocialPhotoUploadViewController.swift
//  NYP25
//
//  Created by TAN on 6/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class UserSocialPhotoUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var takePicture: UIButton!
    @IBOutlet weak var selectPicture: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // We check if this device has a camera
        //
        if !(UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera))
        {
            // If not, we will just hide the takePicture button 
            //
            //takePicture.isHidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This function is called when the user clicks on the 
    // Take Picture button. The purpose of this is to open
    // the Image Picker (using the camera as a source).
    //
    @IBAction func takePicture(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        // Setting this to true allows the user to crop and scale 
        // the image to a square after the photo is taken.
        //
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(
            picker, animated: true)
    }
    
    // This function is called when the user clicks on the
    // Take Picture button. The purpose of this is to open
    // the Image Picker (using the photo library as a source). 
    //
    @IBAction func selectPicture(sender: AnyObject) {
        let picker = UIImagePickerController()
        picker.delegate = self
        
        // Setting this to true allows the user to crop and scale
        // the image to a square after the image is selected.
        //
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(
            picker, animated: true)
    }
    
    // This function is called after the user took the picture,
    // or selected a picture from the photo library.
    // When that happens, we simply assign the image binary,
    // represented by UIImage, into the imageView we created. 
    //
    // iOS doesn’t close the picker controller
    // automatically, so we have to do this ourselves by calling
    // dismissViewControllerAnimated. 
    //
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:[String : AnyObject])
    {
        let chosenImage : UIImage =
            info[UIImagePickerControllerEditedImage] as! UIImage
        self.imageView!.image = chosenImage
        
        picker.dismiss(animated: true)
    }
    
    // This function is called after the user decides not to
    // take/select any picture. iOS doesn’t close the picker controller 
    // automatically, so we have to do this ourselves by calling
    // dismissViewControllerAnimated.
    //
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        picker.dismiss(animated: true)
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
