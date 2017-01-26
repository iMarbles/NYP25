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
    @IBOutlet weak var commentBtn : UIButton!
    
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
        
        if currentPhoto != nil{
            loadImageDetails()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeModal(sender: Any){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteImage(sender: Any){
        let deleteAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to remove the post?", preferredStyle: UIAlertControllerStyle.alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            AdminEventDM.deleteSocialImageBy(socialId: (self.currentPhoto?.socialId)!)
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            //Do nothing
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    @IBAction func safeImage(sender: Any){
        let safeAlert = UIAlertController(title: "Confirm", message: "Are you sure you want to mark the post as safe?", preferredStyle: UIAlertControllerStyle.alert)
        
        safeAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            AdminEventDM.markSocialImageSafeWith(socialId: (self.currentPhoto?.socialId)!)
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        safeAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            //Do nothing
        }))
        
        present(safeAlert, animated: true, completion: nil)
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
            
            if like.comments != nil{
                noOfComments += (like.comments?.count)!
            }
        }
        
        if noOfLikes == 1 {
            likeLbl.text = "\(noOfLikes) like"
        }else{
             likeLbl.text = "\(noOfLikes) Likes"
        }
        
        if noOfComments == 0{
            commentBtn.setTitle("0 Comments", for: UIControlState.normal)
            commentBtn.isEnabled = false
        }
        else if noOfComments == 1{
            commentBtn.setTitle("view \(noOfComments) comment", for: UIControlState.normal)
        }else{
            commentBtn.setTitle("view all \(noOfComments) comments", for: UIControlState.normal)
        }
        
        
        if currentPhoto?.isFlagged == 1{
            reportLbl.text = "This photo has been reported due to:\n\((currentPhoto?.flagReason)!)"
            reportStackView.isHidden = false
        }else{
            reportStackView.isHidden = true
        }
        
        AdminEventDM.retrieveUserPhotoById(userId: (currentPhoto?.uploader)!, onComplete: {
            (photoUrl) in
            if photoUrl != nil{
                GlobalDM.loadImage(imageView: self.userImg, url: photoUrl!)
            }
        })
        
        GlobalDM.loadImage(imageView: socialImage, url: (currentPhoto?.photoUrl)!)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ImageComments"{
            let vc = segue.destination as! AdminEventsGalleryCommentsViewController
            
            if currentPhoto?.likes != nil{
                vc.photoLikes = (currentPhoto?.likes)!
            }
        }
    }

}
