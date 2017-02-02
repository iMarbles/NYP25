//
//  UserSocialDetailsForSoloAlbumViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 2/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialDetailsForSoloAlbumViewController: UIViewController {
    @IBOutlet weak var eventNameLbl : UILabel!
    @IBOutlet weak var venueLbl : UILabel!
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var startTimeLbl : UILabel!
    @IBOutlet weak var endTimeLbl : UILabel!
    
    @IBOutlet weak var descLbl : UILabel!
    @IBOutlet weak var countPhotosLbl : UILabel!

    var eventInfo : Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        eventNameLbl.text = eventInfo?.name
        venueLbl.text = eventInfo?.address
//        dateLbl.text = eventInfo?.date
        dateLbl.text = GlobalDM.getDateNameBy(stringDate: (eventInfo?.date)!)

        startTimeLbl.text = GlobalDM.getTimeInHrBy(stringTime: (eventInfo?.startTime)!)
        endTimeLbl.text = GlobalDM.getTimeInHrBy(stringTime: (eventInfo?.endTime)!)
        descLbl.text = eventInfo?.desc
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AlbumDetailsCollection" {
            let a = segue.destination as! UserSocialViewAlbumPhotosCollectionViewController
            
            a.eventIdLbl = (eventInfo?.eventId)!
        }
    }
}
