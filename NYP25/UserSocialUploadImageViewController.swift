//
//  UserSocialUploadImageViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 17/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialUploadImageViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var txtCaption: UITextView!
    
    var socialImg : Social? = nil
    var newImage: UIImage!

    var eventNames : [Event] = []
    
    @IBOutlet weak var eventsPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        socialImg = Social()
        imageView.image = newImage
    
        loadEventNames()
    }
    
    func loadEventNames(){
        UserSocialDM.retrieveEventNames(onComplete: {(name) in
            self.eventNames = name
            self.eventsPickerView.reloadAllComponents()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventNames.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        return String(describing: eventNames[row])
    }
    
    
    @IBAction func btnSave(sender: AnyObject) {
        var imageData : NSData?
        imageData = UIImageJPEGRepresentation(imageView.image!, 0.6)! as NSData
        //        var compressedJPGImage = UIImage(data: imageData! as Data)
        
        socialImg?.caption = txtCaption.text
        socialImg?.flagReason = txtCaption.text
        socialImg?.postedDateTime = txtCaption.text
        socialImg?.uploader = GlobalDM.CurrentUser!.userId
        socialImg?.isFlagged = 0;
        
        if socialImg != nil{
//            UserSocialDM.createPost(social: socialImg!, socialPhotos: imageData)
            UserSocialDM.createPost(eventId: (GlobalDM.CurrentUser?.userId)!, social: socialImg!, socialPhotos: imageData)
        }
        
//        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
//        var alert = UIAlertView(title: "Wow",
//                                message: "Your image has been saved to Photo Library!",
//                                delegate: nil,
//                                cancelButtonTitle: "Ok")
//        alert.show()
    }
}