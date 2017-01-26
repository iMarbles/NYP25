//
//  UserSocialProfileMasterViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 25/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialProfileMasterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    static func circleFramePhoto (image : UIImageView){
        image.layer.masksToBounds = false
        image.layer.cornerRadius = (image.frame.height)/2
        image.clipsToBounds = true
    }
    
    static func roundedEdgePhoto (image : UIImageView){
        image.layer.cornerRadius = 10
        image.layer.borderWidth = 2.0
        image.layer.masksToBounds = false
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.clear.cgColor
    }
    
    static func loadImage(imageView: UIImageView, url: String)
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
