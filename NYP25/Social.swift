//
//  Social.swift
//  NYP25
//
//  Created by iOS on 6/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class Social: NSObject {
    var uploader : String = ""
    var eventId : String = ""
    var photoUrl : String = ""
    var caption : String?
    var postedDateTime : String = ""
    var isFlagged : Int = 0
    var flagReason : String?
    var likes : [PhotoLike]?
}
