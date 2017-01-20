//
//  AdminEventsDetailViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 23/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class AdminEventsDetailViewController: UIViewController {
    @IBOutlet weak var eventImg : UIImageView!
    @IBOutlet weak var nameLbl : UILabel!
    @IBOutlet weak var dateLbl : UILabel!
    @IBOutlet weak var timeLbl : UILabel!
    @IBOutlet weak var locationLbl : UILabel!
    @IBOutlet weak var descLbl : UILabel!
    @IBOutlet weak var badgeImg : UIImageView!

    var event : Event?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadEventDetails()
    }
    override func viewWillAppear(_ animated: Bool) {
            loadEventDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadEventDetails(){
        if event?.imageUrl != nil{
            loadEventImage(imageView: eventImg, url: (event?.imageUrl)!)
        }else{
            eventImg.isHidden = true
        }
        
        nameLbl.text = event?.name
        if event?.date != nil{
            dateLbl.text = GlobalDM.getDayNameBy(stringDate: (event?.date)!)
        }
        if event?.startTime != nil && event?.endTime != nil{
            timeLbl.text = "\(GlobalDM.getTimeInHrBy(stringTime: (event?.startTime)!)) to \(GlobalDM.getTimeInHrBy(stringTime: (event?.endTime)!))"
        }
        
        if event?.address != nil{
            locationLbl.text = event?.address
        }

        
        if event?.desc != ""{
            descLbl.text = event?.desc
        }
      
        
        if event?.badgeId != nil{
            AdminEventDM.retrieveBadgeByEventId(id: (event?.eventId)!, onComplete: { (badge) in
                self.loadEventImage(imageView: self.badgeImg, url: badge.icon)
                
                self.badgeImg.layer.masksToBounds = false
                self.badgeImg.layer.cornerRadius = self.badgeImg.frame.height/2
                self.badgeImg.clipsToBounds = true
                self.badgeImg.layer.borderWidth = 1
                self.badgeImg.layer.borderColor = UIColor.black.cgColor
            })
        }
    }
    
    func loadEventImage(imageView: UIImageView, url: String)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
