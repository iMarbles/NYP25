
//
//  UserSocialMainListTableViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 17/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialMainListTableViewController: UITableViewController {
    var socialList : [Social] = []
//    var noOfLikesList : [PhotoLike] = []
    
    var likedBy : PhotoLike?
    
    var likes: [String]!
    
    
    var countList : [PhotoLike] = []
//    var commentList : [PhotoLike] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likedBy = PhotoLike()
        
        UserSocialDM.retrieveAllSocial{(dbList) in
            self.socialList = dbList
            self.tableView.reloadData()
            
            
            if(self.socialList.count == 0){
                let alert = UIAlertView(title: "",
                                        message: "No Photos Available Currently",
                                        delegate: nil,
                                        cancelButtonTitle: "Ok")
                alert.show()
                
            }
        }
        
//        UserSocialDM.retrieveAllPhotosForLikeCount(socialId: (socialImg?.socialId)!, onComplete: {(list) in
//            self.countList = list
//            self.countLikesLbl.text = String(self.countList.count)
//        })
//        
//        UserSocialDM.retrieveAllPhotosForCommentCount(socialId: (socialImg?.socialId)!, onComplete: {(list) in
//            self.commentList = list
//            self.countCommentsLbl.text = String(self.commentList.count)
//            
//        })
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        likes = [String](repeating: "like", count: socialList.count)
        return socialList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainListCell", for: indexPath)
            as! UserSocialMainListTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.mainListImageView.image = UIImage(named: "loading-512")
        
        let s = socialList[(indexPath as IndexPath).row]
        cell.dateLbl.text = s.postedDateTime
        if(s.uploaderUsername == nil){
            cell.usernameLbl.text = s.uploader
        }else{
            cell.usernameLbl.text = s.uploaderUsername
        }
        cell.captionLbl.text = s.caption
        
        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(handleLikes), for: .touchUpInside)
        
        cell.btnLike.setTitle(likes[(indexPath as IndexPath).row], for: UIControlState.normal)
        cell.btnLike.setImage(UIImage(named:"Like.png"), for: .normal)

        cell.btnReport.tag = indexPath.row
        cell.btnReport.addTarget(self, action: #selector(actionSheetButtonPressed), for: .touchUpInside)
        
//        UserSocialDM.countTotalLikesForPhoto(socialId: s.socialId, onComplete: {(list) in
//            cell.noOfLikes.text = String(list.isLike)
//        })
        
        UserSocialProfileMasterViewController.loadImage(imageView: cell.mainListImageView, url: s.photoUrl!)
        
        UserSocialDM.retrieveAllPhotosForLikeCount(socialId: s.socialId, onComplete: {(list) in
            self.countList = list
            cell.countLikesLbl.text = String(self.countList.count)
        })

        
        return cell
    }

    func handleLikes(sender: AnyObject){
        UserSocialDM.updateNoOfPhotoLikes(
            socialId: socialList[sender.tag].socialId,
            currentUserId: (GlobalDM.CurrentUser?.userId)!)
        
        
        print("sender.tag - \(sender.tag!)")
        if likes[sender.tag] == "like" {
            likes[sender.tag] = "unlike"
            print("unlike")
            print("sender.tag - \(sender.tag!)")
            sender.setImage(UIImage(named:"Like.png"), for: .normal)
        }
        else {
            likes[sender.tag] = "like"
            print("like")
            sender.setImage(UIImage(named:"LikeFilled.png"), for: .normal)
        }
    }
    
    func actionSheetButtonPressed(sender: AnyObject) {
        let alertController = UIAlertController(title: "Wanna report this post?", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter Flagged Reason"
            
            let reportAction = UIAlertAction(title: "Inappropriate / Irrelevant Post", style: .destructive) { action in
                UserSocialDM.reportPhoto(socialId: self.socialList[sender.tag].socialId, currentUserId: (GlobalDM.CurrentUser?.userId)!, flagReason: "Inappropriate / Irrelevant Post")

            }
            alertController.addAction(reportAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                print("cancel")
            }
            alertController.addAction(cancelAction)
            
            let postAction = UIAlertAction(title: "Submit Reason", style: .destructive) { action in
                UserSocialDM.reportPhoto(socialId: self.socialList[sender.tag].socialId, currentUserId: (GlobalDM.CurrentUser?.userId)!, flagReason: textField.text!)
            }
            alertController.addAction(postAction)
            postAction.isEnabled = false
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { notification in
                if(textField.text == ""){
                    postAction.isEnabled = false
                    reportAction.isEnabled = true
                }else{
                    postAction.isEnabled = true
                    reportAction.isEnabled = false
                }
            }
        }
        
        self.present(alertController, animated: true) {}
    }
    
    @IBAction func actionDelete(sender: UIButton) {
        let alertController = UIAlertController(title: "You sure you wanna delete this post?", message: nil, preferredStyle: .alert)
        
        let destroyAction = UIAlertAction(title: "Delete Post", style: .destructive) { action in
            //            print(action)
            print("destroy")
        }
        alertController.addAction(destroyAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("cancel")
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true) {}
    }
    
}
