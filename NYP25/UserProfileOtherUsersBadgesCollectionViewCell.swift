//
//  UserSocialOtherUsersBadgesCollectionViewCell.swift
//  NYP25
//
//  Created by Evelyn Tan on 6/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialOtherUsersBadgesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var badgePhotos : UIImageView!
    @IBOutlet weak var badgeCheck : UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.badgePhotos.image = UIImage(named: "loading-512")
    }
}
