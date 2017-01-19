//
//  UserSocialMasterForProfileViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 13/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialMasterForProfileViewController: UIViewController {
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var likedPhotosView: UIView!
    @IBOutlet weak var selfUploadView: UIView!

    @IBOutlet weak var usernameLbl: UILabel!
    @IBOutlet weak var profilePhotoView: UIImageView!
    
//    @IBOutlet weak var likedPhotosBtn: UIButton!
//    @IBOutlet weak var selfUploadBtn: UIButton!
    
    @IBAction func likedPhotoBtn(sender: UIButton){
        likedPhotosView.isHidden = true
        selfUploadView.isHidden = false
    }
    
    @IBAction func selfUploadBtn(sender: UIButton){
        likedPhotosView.isHidden = false
        selfUploadView.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likedPhotosView.isHidden = true
        selfUploadView.isHidden = false
        
        /* Circle Profile Photo */
        profilePhotoView.layer.masksToBounds = false
        profilePhotoView.layer.cornerRadius = profilePhotoView.frame.height/2
        profilePhotoView.clipsToBounds = true
        
        UserSocialDM.retrieveAllUserInfo(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: { (user) in
            self.loadSocialImage(imageView: self.profilePhotoView, url: user.displayPhotoUrl!)
            self.usernameLbl.text = user.username
            self.title =  user.username
            
//            self.likedPhotosBtn.setTitle("Button Title", for: UIControlState.normal)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadSocialImage(imageView: UIImageView, url: String)
    {
        DispatchQueue.global(qos: .background).async
            {
                let nurl = URL(string: url)
                var imageBinary : Data?
                if nurl != nil
                {
                    do
                    {
                        imageBinary = try Data(contentsOf: nurl!)
                    }
                    catch
                    {
                        return
                    }
                }
                
                DispatchQueue.main.async
                    {
                        var img : UIImage?
                        if imageBinary != nil
                        {
                            img = UIImage(data: imageBinary!)
                        }
                        
                        imageView.image = img
                        
                }
                
        }
    }
    
    //    @IBAction func indexChanged(sender: UISegmentedControl) {
    //        switch segmentedControl.selectedSegmentIndex {
    //        case 0:
    //            likedPhotosView.isHidden = true
    //            selfUploadView.isHidden = false
    //
    //        case 1:
    //            likedPhotosView.isHidden = false
    //            selfUploadView.isHidden = true
    //
    //        default:
    //            break;
    //        }
    //    }
}
