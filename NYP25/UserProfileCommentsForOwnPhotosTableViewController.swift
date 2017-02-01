//
//  UserProfileCommentsForOwnPhotosTableViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 30/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserProfileCommentsForOwnPhotosTableViewController: UITableViewController {
    var socialImg : Social?
    var coList : [Social] = []
    var commentList : [PhotoComment] = []
    var photoLikes: [PhotoLike] = []
    var newSocialLbl : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserSocialDM.retrieveAllSocialBySocialID(socialId : newSocialLbl, onComplete: { (list) in
            self.photoLikes = list
            self.tableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoLikes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "commentCells", for: indexPath)
            as! UserProfileCommentsForOwnPhotosTableViewCell
        
        
        for a in photoLikes{
            for b in a.comments!{
                commentList.append(b)
            }
            
        }
        
        if(commentList.count != 0){
            cell.usernameLbl.text = commentList[(indexPath as IndexPath).row].username
            cell.commentLbl.text = commentList[(indexPath as IndexPath).row].comment
        }else{
            cell.usernameLbl.isHidden = true
            cell.commentLbl.isHidden = true
            
            let alert = UIAlertView(title: "",
                                    message: "No comments currently",
                                    delegate: nil,
                                    cancelButtonTitle: "Ok")
            alert.show()
        }
    
        return cell
    }
}
