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

    var eventsList : [Event] = []
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

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UserEventsTableViewCell
//        cell.eventLabel.text = "Testing"
        let e = eventsList[(indexPath as IndexPath).row]
        
        cell.eventLabel.text = e.name
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

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        eventToPass = eventsList[indexPath.row]
//        tableView.indexPathForSelectedRow();
        performSegue(withIdentifier: "viewEventDetails", sender: self)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewEventDetails"{
            let dest = segue.destination as! UserEventDetailsViewController
            dest.event = eventToPass
        }
    }
 
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
