//
//  UserSocialMainAlbumTableViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 18/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialMainAlbumTableViewController: UITableViewController {
    var socialList : [Social] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        loadSocial()
    }
    
    func loadSocial(){
        UserSocialDM.retrieveAllSocialAlbum{(dbList) in
            self.socialList = dbList
            self.tableView.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return socialList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTableCell", for: indexPath)
            as! UserSocialMainAlbumTableViewCell
        
        let s = socialList[(indexPath as IndexPath).row]

//        cell.eventLbl.text = s.uploader
//        loadSocialImage(imageView: cell.socialPhoto, url: socialList[(indexPath as IndexPath).row].photoUrl!)
        
        return cell
    }
}
