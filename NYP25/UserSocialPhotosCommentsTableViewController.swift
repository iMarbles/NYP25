//
//  UserSocialPhotosCommentsTableViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 2/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialPhotosCommentsTableViewController: UITableViewController {
    var socialList: [Social] = []
    var photoGallery: [PhotoLike] = []
    var commentList: [PhotoComment] = []

    var socialImg : Social?

    var testing : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        testing  = "\(socialImg?.socialId)"
        
//        print("socialImg?.socialId - \(socialImg?.socialId)")
        
//        UserSocialDM.retrieveAllSocialByID(socialId: (socialImg?.socialId)!, onComplete: {(list) in
//            self.socialList = list
//            self.tableView.reloadData()
//        })
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        
        UserSocialDM.retrieveAllSocial(onComplete: {(list) in
            self.socialList = list
            self.tableView.reloadData()
            
            for a in self.socialList{
                for b in a.likes!{
                    for c in b.comments!{
                        self.commentList.append(c)
                        
                        self.commentList.sort { (a, b) -> Bool in
                            if a.timestamp! > b.timestamp!{
                                return true
                            }else{
                                return false
                            }
                        }
                    }
                }
            }
        })

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "commentCells", for: indexPath)
            as! UserSocialListCommentsTableViewCell
        
        if(commentList.count != 0){
            cell.usernameLbl.text = commentList[(indexPath as IndexPath).row].username
            cell.commentLbl.text = commentList[(indexPath as IndexPath).row].comment
            cell.dateLbl.text = commentList[(indexPath as IndexPath).row].timestamp
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
