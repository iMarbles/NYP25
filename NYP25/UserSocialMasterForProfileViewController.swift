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
    
    @IBAction func indexChanged(sender: UISegmentedControl) {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            likedPhotosView.isHidden = false
            selfUploadView.isHidden = true
            
        case 1:
            likedPhotosView.isHidden = true
            selfUploadView.isHidden = false
            
        default:
            break;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserSocialDM.retrieveAllUserInfo(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: { (user) in
            self.loadSocialImage(imageView: self.profilePhotoView, url: user.displayPhotoUrl!)
            self.usernameLbl.text = user.username
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
}
