//
//  UserInboxMainTableViewCell.swift
//  NYP25
//
//  Created by Zhen Wei on 30/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserInboxMainTableViewCell: UITableViewCell {
    @IBOutlet weak var eventImg : UIImageView!
    @IBOutlet weak var rateLbl : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
