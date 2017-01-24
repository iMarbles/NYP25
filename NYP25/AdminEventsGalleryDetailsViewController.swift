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
    @IBOutlet weak var likeLbl : UILabel!
    @IBOutlet weak var commentLbl : UILabel!
    
    @IBOutlet weak var reportStackView : UIStackView!
    @IBOutlet weak var reportLbl : UILabel!
    
    var currentPhoto: Social?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        userImg.layer.masksToBounds = false
        userImg.layer.cornerRadius = userImg.frame.height/2
        userImg.clipsToBounds = true
        userImg.layer.borderWidth = 1
        userImg.layer.borderColor = UIColor.black.cgColor
        
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
        userLbl.text = currentPhoto?.uploaderUsername
        captionLbl.text = currentPhoto?.caption
        
        //For likes and comments
        var noOfLikes = 0
        var noOfComments = 0
        for like in (currentPhoto?.likes)!{
            if like.isLike == 1{
                noOfLikes += 1
            }
            
            noOfComments = (like.comments?.count)!
        }
        
        if noOfLikes == 1 {
            likeLbl.text = "\(noOfLikes) like"
        }else{
             likeLbl.text = "\(noOfLikes) Likes"
        }
        
        if noOfComments == 0{
            commentLbl.text = "0 Comments"
        }
        else if noOfComments == 1{
            commentLbl.text = "view \(noOfComments) comment"
        }else{
            commentLbl.text = "view all \(noOfComments) comments"
        }
        
        
        if currentPhoto?.isFlagged == 1{
            reportLbl.text = "This photo has been reported due to: \(currentPhoto?.flagReason)"
            reportStackView.isHidden = false
        }else{
            reportStackView.isHidden = true
        }
        
        AdminEventDM.retrieveUserPhotoById(userId: (currentPhoto?.uploader)!, onComplete: {
            (photoUrl) in
            if photoUrl != nil{
                self.loadImage(imageView: self.userImg, url: photoUrl!)
            }
        })
        
        loadImage(imageView: socialImage, url: (currentPhoto?.photoUrl)!)
    }
    
    func loadImage(imageView: UIImageView, url: String)
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
