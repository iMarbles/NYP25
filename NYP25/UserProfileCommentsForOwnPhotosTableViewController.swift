//
//  UserProfileCommentsForOwnPhotosTableViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 30/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileCommentsForOwnPhotosTableViewController: UITableViewController {
    var social : Social?
    var coList : [Social] = []

    var co : PhotoComment?
    var commentList : [PhotoComment] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        UserSocialDM.retrieveAllSocial(onComplete: { (list) in
            self.coList = list
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "commentCells", for: indexPath)
            as! UserProfileCommentsForOwnPhotosTableViewCell
        
//        for like in coList[indexPath.row].likes!{
//        }
        
        //cell.usernameLbl.text =
        //cell.commentLbl.text = co?.comment
        
        return cell
    }
}
