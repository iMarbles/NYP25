//
//  UserSocialMainAlbumTableViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 18/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialMainAlbumTableViewController: UITableViewController {
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
        // #warning Incomplete implementation, return the number of rows
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
}
