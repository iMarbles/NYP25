//
//  UserProfileSettingViewBadgesCollectionViewCell.swift
//  NYP25
//
//  Created by Evelyn Tan on 27/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileSettingViewBadgesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var badgePhotos : UIImageView!
    @IBOutlet weak var badgeCheck : UIImageView!
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.badgePhotos.image = UIImage(named: "loading-512")
    }
}
