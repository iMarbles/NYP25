//
//  Social.swift
//  NYP25
//
//  Created by iOS on 6/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class Social: NSObject {
    var socialId : String = ""
    var eventId : String = ""
    var photoUrl : String?
    var uploader : String?
    var caption : String?
    var postedDateTime : String?
    var isFlagged : Int = 0
    var noOfFlag : Int = 0
    var flagReasons : [String]?
    var likes : [PhotoLike]?
    
    var uploaderUsername : String?
}
