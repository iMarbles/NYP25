//
//  UserSocialCommentsForOwnPhotosTableViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 30/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialCommentsForOwnPhotosTableViewController: UITableViewController {
    var socialImg : Social?
    var coList : [Social] = []
    var commentList : [PhotoComment] = []
    var photoGallery: [PhotoLike] = []
    var newSocialLbl : String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        for a in photoGallery{
            for b in a.comments!{
                commentList.append(b)
                
                commentList.sort { (a, b) -> Bool in
                    if a.timestamp! > b.timestamp!{
                        return true
                    }else{
                        return false
                    }
                }
            }
        }
        
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("commentList.count - \(commentList.count)")

        return commentList.count

    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "commentCells", for: indexPath)
            as! UserProfileCommentsForOwnPhotosTableViewCell
        
        if(commentList.count != 0){
            cell.usernameLbl.text = commentList[(indexPath as IndexPath).row].username
            cell.commentLbl.text = commentList[(indexPath as IndexPath).row].comment
            cell.dateLbl.text = GlobalDM.getCommentDateTimeBy(stringDate: commentList[(indexPath as IndexPath).row].timestamp!)
        }else{
            cell.usernameLbl.isHidden = true
            cell.commentLbl.isHidden = true
            cell.dateLbl.isHidden = true
            
            let alert = UIAlertView(title: "",
                                    message: "No comments currently",
                                    delegate: nil,
                                    cancelButtonTitle: "Ok")
            alert.show()
        }
    
        return cell
    }
}
