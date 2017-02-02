//
//  UserSocialListCommentsTableViewCell.swift
//  NYP25
//
//  Created by Evelyn Tan on 2/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialListCommentsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var usernameLbl : UILabel!
    @IBOutlet weak var commentLbl : UILabel!
    @IBOutlet weak var dateLbl : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
