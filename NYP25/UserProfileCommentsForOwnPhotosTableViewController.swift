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

    var pl : PhotoLike?
    var co : PhotoComment?
    var commentList : [PhotoComment] = []
    
    var photoLikes: [PhotoLike] = []

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
        
        print("coList[(indexPath as IndexPath).row].socialId - \(coList[(indexPath as IndexPath).row].socialId)")
        
        
        for a in coList{
            print(a.socialId)
            for b in a.likes!{
                for comment in b.comments!{
                    commentList.append(comment)
                }
            }
        }
        
        let cl = commentList[(indexPath as IndexPath).row]
        cell.usernameLbl.text = cl.username
        cell.commentLbl.text = cl.comment
        
        return cell
    }
}
