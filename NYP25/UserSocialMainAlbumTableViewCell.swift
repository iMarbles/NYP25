//
//  UserSocialMainAlbumTableViewCell.swift
//  NYP25
//
//  Created by Evelyn Tan on 18/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialMainAlbumTableViewCell: UITableViewCell {
    @IBOutlet weak var eventLbl : UILabel!
    @IBOutlet weak var noOfLikes : UILabel!
    @IBOutlet weak var socialPhoto : UIImageView!


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
