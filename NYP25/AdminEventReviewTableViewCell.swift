//
//  AdminEventReviewTableViewCell.swift
//  NYP25
//
//  Created by Zhen Wei on 30/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class AdminEventReviewTableViewCell: UITableViewCell {
    @IBOutlet weak var usernameLbl : UILabel!
    @IBOutlet weak var reviewLbl : UILabel!
    @IBOutlet weak var star1 : UIImageView!
    @IBOutlet weak var star2 : UIImageView!
    @IBOutlet weak var star3 : UIImageView!
    @IBOutlet weak var star4 : UIImageView!
    @IBOutlet weak var star5 : UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
