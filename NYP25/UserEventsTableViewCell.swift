//
//  UserEventsTableViewCell.swift
//  NYP25
//
//  Created by Kenneth on 30/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserEventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventBannerImg : UIImageView!
    @IBOutlet weak var eventLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var venueLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.eventBannerImg.image = UIImage(named: "loading-512")
        self.eventLabel.text = "Loading..."
        self.dateLabel.text = nil;
        self.venueLabel.text = nil;
    }

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    
    

}
