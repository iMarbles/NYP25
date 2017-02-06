//
//  UserSocialOthersProfileCollectionViewCell.swift
//  NYP25
//
//  Created by Evelyn Tan on 6/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialOthersProfileCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var ownPhotos : UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.ownPhotos.image = UIImage(named: "loading-512")
    }
}
