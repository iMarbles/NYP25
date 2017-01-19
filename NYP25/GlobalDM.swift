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
    
    //School colours
    static var sbmCol : UIColor = UIColor.purple
    static var sclCol : UIColor = UIColor(red:0.80, green:0.80, blue:0.00, alpha:1.0)
    static var sdnCol : UIColor = UIColor.orange
    static var segCol : UIColor = UIColor.red
    static var shsCol : UIColor = UIColor(red:0.20, green:0.80, blue:0.20, alpha:1.0)
    static var sitCol : UIColor = UIColor.blue
    static var sidmCol : UIColor = UIColor.magenta
    
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
