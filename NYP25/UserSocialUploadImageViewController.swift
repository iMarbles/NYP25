//
//  UserSocialUploadImageViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 17/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialUploadImageViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
//    @IBOutlet weak var txtCaption: UITextField!
    @IBOutlet weak var txtCaption: UITextView!
    
    var socialImg : Social? = nil
    
    var newImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        socialImg = Social()
        imageView.image = newImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            UserSocialDM.createPost(social: socialImg!, socialPhotos: imageData)
        }
        
//        UIImageWriteToSavedPhotosAlbum(compressedJPGImage!, nil, nil, nil)
//        var alert = UIAlertView(title: "Wow",
//                                message: "Your image has been saved to Photo Library!",
//                                delegate: nil,
//                                cancelButtonTitle: "Ok")
//        alert.show()
    }
}
