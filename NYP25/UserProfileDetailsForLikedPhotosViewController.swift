//
//  UserProfileDetailsForLikedPhotosViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 29/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileDetailsForLikedPhotosViewController: UIViewController {
    @IBOutlet weak var photoIdLbl : UILabel!
    
    var newLbl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //photoId from grid controller
        photoIdLbl.text = newLbl
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
