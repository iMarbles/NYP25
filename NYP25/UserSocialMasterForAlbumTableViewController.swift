//
//  UserSocialMasterForAlbumTableViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 18/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialMasterForAlbumTableViewController: UITableViewController {
    var eventNameList : [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UserSocialDM.retrieveEventNames(onComplete: { (nameList) in
            self.eventNameList = nameList
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventNameList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTableCell", for: indexPath)
            as! UserSocialMainAlbumTableViewCell
        
        cell.socialPhotoView?.image = UIImage(named: "loading-512")

        let s = eventNameList[(indexPath as IndexPath).row]
        cell.eventNameLbl.text = s.name
        cell.totalNoOfPhotosLbl.text = String(eventNameList.count)
        UserSocialProfileMasterViewController.loadImage(imageView: cell.socialPhotoView, url: eventNameList[(indexPath as IndexPath).row].imageUrl!)
        
        return cell
    }
    
    @IBAction func btnUpload(sender: AnyObject) {
        if(eventNameList.count != 0){
            let storyBoard : UIStoryboard = UIStoryboard(name: "UserSocial", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UserSocialSelectImage") as! UserSocialSelectImageViewController
            self.navigationController?.pushViewController(nextViewController, animated: true)
        }else{
            var alert = UIAlertView(
                title: nil,
                message: "Sorry, there's no album available currently for upload!",
                delegate: nil,
                cancelButtonTitle: "Ok")
            alert.show()
            
        }        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AlbumDetails" {
            let a = segue.destination as! UserSocialDetailsForSoloAlbumViewController
            
            let cell = sender as? UserSocialMainAlbumTableViewCell
            let indexPath = tableView?.indexPath(for: cell!)
            
            a.eventInfo = eventNameList[(indexPath?.row)!]
        }
    }
}
