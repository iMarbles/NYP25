//
//  UserEventsTableViewController.swift
//  NYP25
//
//  Created by Kenneth on 31/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserEventsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let adm = GlobalDM.CurrentUser?.userId
    var tempName : String = "title"
    var eventsList : [Event] = []
    var sortedList : [Event] = []
    var eventToPass : Event = Event()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadEvents()
        for (index, element) in eventsList.enumerated() {
            print("Item \(index): \(element)")
        }
        
        tableView.reloadData()
        

    }
    
    func loadEvents() {
        UserEventDM.loadEvents { (eventListFromDatabase) in
            self.eventsList = eventListFromDatabase
            var dateString : Int = 0
            for i in self.eventsList { // homemade sorting by kenif
                let dbDate : Int = Int(i.date!)!
                if dbDate < dateString {
                    self.sortedList.insert(i, at: 0)
                } else {
                    self.sortedList.append(i)
                }
                dateString = dbDate
            }
            self.eventsList = self.sortedList
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return eventsList.count
    }
    
    func updateCellLabel(text: String) {
        tempName = text
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserEventsTableViewCell
//        cell.eventLabel.text = "Testing"
        let e = eventsList[(indexPath as IndexPath).row]
        
        UserEventDM.checkIfRSVP(adm: adm!, eventId: e.eventId, onComplete: { (msg) in
            print(msg)
            if msg == "EXIST" {
                self.updateCellLabel(text: e.name! + " ✅")
            } else if msg == "NOT" {
                self.updateCellLabel(text: e.name!)
            }
            
            cell.eventLabel.text = self.tempName
        })
//        cell.eventLabel.text = e.name
        cell.dateLabel.text = e.date
        if e.date != nil && e.startTime != nil{
            let day = GlobalDM.getDayNameBy(stringDate: e.date!)
            let time = GlobalDM.getTimeInHrBy(stringTime: e.startTime!)
            cell.dateLabel.text = "\(day) @ \(time)"
        }
        
        cell.venueLabel.text = e.address
        
        if(e.imageUrl != nil){
            GlobalDM.loadImage(imageView: cell.eventBannerImg, url: e.imageUrl!)
        }else{
            cell.eventBannerImg.image = UIImage(named: "loading-512")
        }
        
        
        cell.selectionStyle = .none

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventToPass = eventsList[indexPath.row]
//        tableView.indexPathForSelectedRow();
        performSegue(withIdentifier: "viewEventDetails", sender: self)
        
        
        // some over view controller could have changed our nav bar tint color, so reset it here
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewEventDetails"{
            let dest = segue.destination as! UserEventDetailsViewController
            dest.event = eventToPass
        }
    }
 
}
