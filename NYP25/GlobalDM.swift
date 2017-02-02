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
    
    
    static func getDateNameBy(stringDate: String) -> String     //Evelyn
    {
        let df  = DateFormatter()
        df.dateFormat = "YYYYMMdd"
        
        let date = df.date(from: stringDate)!
        df.dateFormat = "EEE, dd MMM YYYY"
        return df.string(from: date);
    }
    
    static func getCommentDateTimeBy(stringDate: String) -> String     //Evelyn
    {
        let df  = DateFormatter()
        df.dateFormat = "yyyyMMdd, HH:mm:ss"
        
        let date = df.date(from: stringDate)!
        df.dateFormat = "dd MMM YYYY, HH:mm"
        return df.string(from: date);
    }
    
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
    
    static func loadImage(imageView: UIImageView, url: String)
    {
        DispatchQueue.global(qos: .background).async
            {
                let nurl = URL(string: url)
                var imageBinary : Data?
                if nurl != nil
                {
                    do
                    {
                        imageBinary = try Data(contentsOf: nurl!)
                    }
                    catch
                    {
                        return
                    }
                }
                
                DispatchQueue.main.async
                    {
                        var img : UIImage?
                        if imageBinary != nil
                        {
                            img = UIImage(data: imageBinary!)
                        }
                        
                        imageView.image = img
                }
                
        }
    }
    
    
}
