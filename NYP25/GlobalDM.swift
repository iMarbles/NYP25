//
//  GlobalDM.swift
//  NYP25
//
//  Created by iOS on 2/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class GlobalDM: NSObject {
    static var CurrentUser : User?
    static var CurrentStudent : Student?
    
    static func getDayNameBy(stringDate: String) -> String
    {
        let df  = DateFormatter()
        df.dateFormat = "YYYYMMdd"
        
        let date = df.date(from: stringDate)!
        df.dateFormat = "EEE, MMM dd"
        return df.string(from: date);
    }
    
    static func getTimeInHrBy(stringTime: String) -> String
    {
        let df  = DateFormatter()
        df.dateFormat = "HHmm"
        
        let date = df.date(from: stringTime)!
        df.dateFormat = "h:mm a"
        return df.string(from: date);
    }
}
