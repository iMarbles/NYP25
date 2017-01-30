//
//  UserInboxRateViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 30/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserInboxRateViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var star1 : UIImageView!
    @IBOutlet weak var star2 : UIImageView!
    @IBOutlet weak var star3 : UIImageView!
    @IBOutlet weak var star4 : UIImageView!
    @IBOutlet weak var star5 : UIImageView!
    
    @IBOutlet weak var eventNameLbl : UILabel!
    @IBOutlet weak var commentTb : UITextView!
    
    var event : Event?
    let feedback = EventFeedback()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if event != nil{
            eventNameLbl.text = event?.name
        }
        
        //Setting the initial feedback user
        feedback.userId = (GlobalDM.CurrentUser?.userId)!
        
        //For the textboxes
        commentTb.delegate = self
        commentTb.text = "Enter comments"
        commentTb.textColor = UIColor.lightGray
        commentTb.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        commentTb.layer.borderWidth = 1.0;
        commentTb.layer.cornerRadius = 5.0;
        
        //To dismiss keyboard on tap
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func starTapped(sender: AnyObject){
        let selectedRating = sender.view.tag
        
        feedback.rating = selectedRating
        
        //Logic to show yellow stars
        star1.image = getStarImage(starNumber: 1, forRating: selectedRating)
        star2.image = getStarImage(starNumber: 2, forRating: selectedRating)
        star3.image = getStarImage(starNumber: 3, forRating: selectedRating)
        star4.image = getStarImage(starNumber: 4, forRating: selectedRating)
        star5.image = getStarImage(starNumber: 5, forRating: selectedRating)
    }
    
    func getStarImage(starNumber: Int, forRating rating: Int) -> UIImage {
        let emptyStar = UIImage(named: "Star-50")!
        let fullStar = UIImage(named: "Yellow Star Filled-50")!
        
        if rating >= starNumber {
            return fullStar
        } else {
             return emptyStar
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter comments"
            textView.textColor = UIColor.lightGray
            feedback.comment = "No comments"
        }else{
            feedback.comment = textView.text
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitFeedback(sneder: AnyObject){
        //Do the setting of user here due to slow async
        UserProfileDM.retrieveUsersInfo(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: {
            (student) in
            self.feedback.username = student.username
            
            UserInboxDM.createFeedbackFor(eventId: (self.event?.eventId)!, feedback: self.feedback, onComplete: {
                (msg) in
                
                if msg == "OK"{
                    self.navigationController?.popViewController(animated: true)
                }
            })
        })
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
