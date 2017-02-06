//
//  UserInboxAcknowledgeReportViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 6/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserInboxAcknowledgeReportViewController: UIViewController {
    @IBOutlet weak var socialImage : UIImageView!
    @IBOutlet weak var reportLbl : UILabel!
    
    var currentImg :  Social?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadImg()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadImg(){
        GlobalDM.loadImage(imageView: socialImage, url: (currentImg?.photoUrl)!)
        reportLbl.text = "This image has been reported \((currentImg?.flagReasons?.count)!) times"
    }
    
    @IBAction func deleteImg(sender: Any){
        UserInboxDM.deleteSocialImageBy(socialId: (self.currentImg?.socialId)!)
        
        self.navigationController?.popViewController(animated: true)
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
