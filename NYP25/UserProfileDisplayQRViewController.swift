//
//  UserProfileDisplayQRViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 27/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileDisplayQRViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var imgQRCode: UIImageView!
    
    @IBOutlet weak var btnAction: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    var qrcodeImage: CIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func performButtonAction(sender: AnyObject) {
        if qrcodeImage == nil {
            if textField.text == "" {
                return
            }
            
            let data = textField.text?.data(using: String.Encoding.isoLatin1, allowLossyConversion: false)
            
            let filter = CIFilter(name: "CIQRCodeGenerator")
            
            filter?.setValue(data, forKey: "inputMessage")
            filter?.setValue("Q", forKey: "inputCorrectionLevel")
            
            qrcodeImage = filter?.outputImage
            
            textField.resignFirstResponder()
         
            btnAction.setTitle("Clear", for: UIControlState.normal)
            
            displayQRCodeImage()
        }
        else {
            imgQRCode.image = nil
            qrcodeImage = nil
            btnAction.setTitle("Generate", for: UIControlState.normal)
        }
        
        textField.isEnabled = !textField.isEnabled
        slider.isHidden = !slider.isHidden
    }
    
    
    @IBAction func changeImageViewScale(sender: AnyObject) {
        imgQRCode.transform = CGAffineTransform(scaleX: CGFloat(slider.value), y: CGFloat(slider.value))
    }
    
    func displayQRCodeImage() {
        let scaleX = imgQRCode.frame.size.width / qrcodeImage.extent.size.width
        let scaleY = imgQRCode.frame.size.height / qrcodeImage.extent.size.height
        
        let transformedImage = qrcodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        imgQRCode.image = UIImage(ciImage: transformedImage)
        
        
    }
    
}
