//
//  AdminStatisticsMoreTableViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 19/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Charts

class AdminStatisticsMoreTableViewController: UITableViewController {
    let schools = ["SBM", "SCL", "SDN", "SEG", "SHS", "SIT", "SiDM"]
    let schoolColors = [UIColor.purple, UIColor.yellow, UIColor.orange, UIColor.red, UIColor.green, UIColor.blue, UIColor.magenta]
    
    var eventList : [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        loadAllEventsForUse()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return schools.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChartCell", for: indexPath) as! AdminStatisticsMoreTableViewCell

        // Configure the cell...
        cell.schoolLbl.text = schools[(indexPath as IndexPath).row]
        
        cell.isUserInteractionEnabled = false

        return cell
    }
    
    func createChartForSchool(){
        
    }
    
    //For onload
    func loadAllEventsForUse(){
        AdminEventDM.retrieveAllEvents(onComplete: { (listFromDb) in
            self.eventList = listFromDb
            self.sortEvents()
        })
    }
    
    func sortEvents(){
        var tempList : [Event] = []
        for event in eventList{
            //Conditions for it to appear on graph (later on to include visbility)
            if event.date != nil{
                tempList.append(event)
            }
        }
        
        tempList.sort { (a, b) -> Bool in
            if a.date! < b.date!{
                return true
            }else{
                return false
            }
        }
        
        eventList = tempList
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
