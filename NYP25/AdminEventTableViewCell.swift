//
//  AdminEventTableViewCell.swift
//  NYP25
//
//  Created by Zhen Wei on 23/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class AdminEventTableViewCell: UITableViewCell {
    @IBOutlet weak var eventImg : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var locationLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
