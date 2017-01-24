//
//  AdminEventsGalleryDetailsViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 23/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class AdminEventsGalleryDetailsViewController: UIViewController {
    @IBOutlet weak var userImg : UIImageView!
    @IBOutlet weak var userLbl : UILabel!
    @IBOutlet weak var socialImage: UIImageView!
    @IBOutlet weak var captionLbl : UILabel!
    @IBOutlet weak var infoLbl : UILabel!
    @IBOutlet weak var reportStackView : UIStackView!
    @IBOutlet weak var reportLbl : UILabel!
    
    var currentPhoto: Social! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadImageDetails()
      
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeModal(sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    func loadImageDetails(){
        loadSocialmage(imageView: userImg, url: currentPhoto.photoUrl!)
    }
    
    func loadSocialmage(imageView: UIImageView, url: String)
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
