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
    
    var likedBy : PhotoLike? = nil
    var comments : PhotoComment? = nil

    var eventNames : [Event] = []

    var valueSelected = "";
    
    @IBOutlet weak var eventsPickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        socialImg = Social()
        likedBy = PhotoLike()
        comments = PhotoComment()
        
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
    
    @IBAction func btnSave(sender: AnyObject) {
        var imageData : NSData?
        imageData = UIImageJPEGRepresentation(imageView.image!, 0.6)! as NSData
        //        var compressedJPGImage = UIImage(data: imageData! as Data)
        
//        var selectedValue = eventNames[pickerView.selectedRowInComponent(0)]
                
        //Social
        socialImg?.caption = txtCaption.text
        socialImg?.flagReason = txtCaption.text
        socialImg?.postedDateTime = txtCaption.text
        socialImg?.uploader = GlobalDM.CurrentUser!.userId
        socialImg?.isFlagged = 0;
        socialImg?.eventId = valueSelected
        
        //Liked By
        likedBy?.adminNo = GlobalDM.CurrentUser!.userId
        likedBy?.isLike = 0;
        
        //Empty Comments
//        comments?.comment = ""
//        comments?.timestamp = ""
//        comments?.username = ""
        
        if socialImg != nil{
            UserSocialDM.createPost(
                eventId: (GlobalDM.CurrentUser?.userId)!,
                social: socialImg!,
                socialPhotos: imageData,
//                likedBy : likedBy!,
                currentUserId: (GlobalDM.CurrentUser?.userId)!
//                comments : comments!
            )
        }
        
        //        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
        //        var alert = UIAlertView(title: "Wow",
        //                                message: "Your image has been saved to Photo Library!",
        //                                delegate: nil,
        //                                cancelButtonTitle: "Ok")
        //        alert.show()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventNames.count;
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String {
        return String(describing: eventNames[row].name!)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        valueSelected = eventNames[row].eventId as String
    }
    
//    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
//    {
//        eventNames[row].name!
    
//        if(row == 0)
//        {
//            self.view.backgroundColor = UIColor.whiteColor();
//        }
//        else if(row == 1)
//        {
//            self.view.backgroundColor = UIColor.redColor();
//        }
//        else if(row == 2)
//        {
//            self.view.backgroundColor =  UIColor.greenColor();
//        }
//        else
//        {
//            self.view.backgroundColor = UIColor.blueColor();
//        }
//    }
}
