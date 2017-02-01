//
//  UserSocialMainListTableViewCell.swift
//  NYP25
//
//  Created by Evelyn Tan on 17/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Firebase

//protocol ButtonCellDelegate {
//    func cellTapped(_ cell: UserSocialMainListTableViewCell)
////    func setImg(btn : UIButton)
//}

class UserSocialMainListTableViewCell: UITableViewCell {    
    @IBOutlet weak var usernameLbl : UILabel!
    @IBOutlet weak var captionLbl : UITextView!
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var noOfLikes : UILabel!
    @IBOutlet weak var mainListImageView : UIImageView!

    @IBOutlet weak var btnLike: UIButton!
    @IBOutlet weak var btnReport: UIButton!

    @IBOutlet weak var likeLbl: UILabel!
    @IBOutlet weak var hintLbl : UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.mainListImageView.image = UIImage(named: "loading-512")
    }
    
//    @IBAction func likeBtn(sender: UIButton!) {
//        if let delegate = buttonDelegate {
//            delegate.cellTapped(self)
////            delegate.setImg(img: UIImage(named:"LikeFilled.png")!)
//        }
//    }
    
//    var icon = UIImage(named: "LikeFilled")! as UIImage
//    sender.setImage(icon, for: .normal)
//    
//    if(icon == UIImage(named: "LikeFilled.png")){
//    icon = UIImage(named: "Like.png")!
//    sender.setImage(UIImage(named:"Like.png"), for: .normal)
//    }else if (icon == UIImage(named:"Like.png")){
//    icon = UIImage(named: "LikeFilled.png")!
//    sender.setImage(UIImage(named:"LikeFilled.png"), for: .highlighted)
//    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
