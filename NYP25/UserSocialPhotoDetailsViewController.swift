//
//  UserSocialPhotoDetailsViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 28/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialPhotoDetailsViewController: UIViewController {

    @IBOutlet weak var eventIdLbl : UILabel!
    
    var newLbl : String = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        //eventId from grid controller
        eventIdLbl.text = newLbl
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
