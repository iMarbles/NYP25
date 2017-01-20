//
//  Student.swift
//  NYP25
//
//  Created by iOS on 1/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class Student: User {
    var name : String = ""
    var username : String = ""
    var points : Int = 0
    var bio : String?
    var displayPhotoUrl : String?
    var badges : [Badge]?
}
