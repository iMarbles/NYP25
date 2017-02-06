//
//  UserInboxTableViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 30/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserInboxTableViewController: UITableViewController {
    
    var eventList : [Event] = []
    var eventToFeedbackList : [Event] = []
    
    var reportedSocialList : [Social] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        loadEventsToFeedback()
        loadDeletedImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loadEventsToFeedback(){
        eventList = []
        eventToFeedbackList = []

        UserInboxDM.retrieveAllEvents { (listFromDb) in
            self.eventList = listFromDb
            self.eventToFeedbackList = []
            
            UserInboxDM.retrieveAllAttendanceBy(userId: (GlobalDM.CurrentUser?.userId)!, onComplete: {(stringEventId) in
                for eventId in stringEventId {
                    let find = self.eventList.first(where: {$0.eventId == eventId})
                    
                    if find != nil{
                        var found = false
                        //Check feedbacklist of the event (find)
                        for f in (find?.feedbackList)!{
                            if f.userId == GlobalDM.CurrentUser?.userId{
                                found = true
                            }
                        }
                        //If feedback not found, have to make person feedback
                        if !found{
                            self.eventToFeedbackList.append(find!)
                        }
                    }
                }
                
                self.tableView.reloadData()

            })
        }
    }
    
    func loadDeletedImages(){
        UserInboxDM.retrieveFlaggedSocialImage { (deletedPhotoList) in
            self.reportedSocialList = []
            for photo in deletedPhotoList{
                if photo.uploader == GlobalDM.CurrentUser?.userId{
                    self.reportedSocialList.append(photo)
                }
            }
            self.tableView.reloadData()
        }
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if section == 0{
            return eventToFeedbackList.count
        }
        else {
            return reportedSocialList.count
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Rate Events"
        }
        else{
         return "Reported Photos"
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InboxCell", for: indexPath) as! UserInboxMainTableViewCell
        
        let row = (indexPath as IndexPath).row
        let section = indexPath.section
        
        // Configure the cell...
        cell.eventImg.image = UIImage(named: "loading-512")
        if section == 0{
            GlobalDM.loadImage(imageView: cell.eventImg, url: eventToFeedbackList[row].imageUrl!)
            cell.rateLbl.text = "\(eventToFeedbackList[row].name!)"
        }else if section == 1{
            GlobalDM.loadImage(imageView: cell.eventImg, url: reportedSocialList[row].photoUrl!)
            cell.rateLbl.text = "This photo has been reported and removed"
        }

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedSection = indexPath.section
        
        if selectedSection == 0 {
            self.performSegue(withIdentifier: "RateEvent", sender: self)
        }
        if selectedSection == 1 {
            self.performSegue(withIdentifier: "AcknowledgeReport", sender: self)
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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "RateEvent"{
            let vc = segue.destination as! UserInboxRateViewController
            
            let selectedRow = tableView.indexPathForSelectedRow! as IndexPath
            vc.event = eventToFeedbackList[selectedRow.row]
        }
        
        if segue.identifier == "AcknowledgeReport"{
            let vc = segue.destination as! UserInboxAcknowledgeReportViewController
            
            let selectedRow = tableView.indexPathForSelectedRow! as IndexPath
            vc.currentImg = reportedSocialList[selectedRow.row]
        }
    }
}
