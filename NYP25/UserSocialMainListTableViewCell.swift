//
//  UserSocialMainListTableViewCell.swift
//  NYP25
//
//  Created by Evelyn Tan on 17/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialMainListTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLbl : UILabel!
    @IBOutlet weak var captionLbl : UITextView!
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var mainListImageView : UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
