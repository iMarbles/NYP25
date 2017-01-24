//
//  UserSocialMainListTableViewCell.swift
//  NYP25
//
//  Created by Evelyn Tan on 17/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit


protocol ButtonCellDelegate {
    func cellTapped(_ cell: UserSocialMainListTableViewCell)
}

class UserSocialMainListTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLbl : UILabel!
    @IBOutlet weak var captionLbl : UITextView!
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var noOfLikes : UILabel!
    @IBOutlet weak var mainListImageView : UIImageView!

    
    
    var buttonDelegate: ButtonCellDelegate?
        
    @IBAction func likeBtn(sender: UIButton!) {
        if let delegate = buttonDelegate {
            delegate.cellTapped(self)
            
            let image = UIImage(named: "LikeFilled-30.png") as UIImage!
            sender.setImage(image, for: .normal)
            
//            if let p1 = UIImage(named:"LikeFilled-30") {
//                sender.setImage(UIImage(named:"Like-30-2.png"), for: .normal)
//            }else if let p2 = UIImage(named:"Like-30-2") {
//                sender.setImage( UIImage(named:"LikeFilled-30.png"), for: .normal)
//            }
        }
    }
    
//    @IBAction func likeBtn(sender: UIButton) {
//        if let p1 = UIImage(named:"LikeFilled-30") {
//            sender.setImage(UIImage(named:"Like-30-2.png"), for: .normal)
//        }
//        if let p2 = UIImage(named:"Like-30-2") {
//            sender.setImage( UIImage(named:"LikeFilled-30.png"), for: .normal)
//        }
//        UserSocialDM.updateNoOfPhotoLikes(eventId: socialList[0].eventId, currentUserId: (GlobalDM.CurrentUser?.userId)!, likedBy: likedBy)
//    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
