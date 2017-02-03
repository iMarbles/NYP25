//
//  UserSocialSelectAlbumTableViewCell.swift
//  NYP25
//
//  Created by Evelyn Tan on 3/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialSelectAlbumTableViewCell: UITableViewCell {
    @IBOutlet weak var eventNameLbl : UILabel!
    @IBOutlet weak var totalNoOfPhotosLbl : UILabel!
    @IBOutlet weak var eventDateLbl : UILabel!
    @IBOutlet weak var socialPhotoView : UIImageView!
//    @IBOutlet weak var selectedAlbum : UIImageView!

    override func prepareForReuse() {
        super.prepareForReuse()
        self.socialPhotoView.image = UIImage(named: "loading-512")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
