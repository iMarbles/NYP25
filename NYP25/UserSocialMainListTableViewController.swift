
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
    var noOfLikesList : [PhotoLike] = []
    
    var likedBy : PhotoLike?
    
    var likes: [String]!
    
    var hint : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likedBy = PhotoLike()
        
        UserSocialDM.retrieveAllSocial{(dbList) in
            self.socialList = dbList
            self.tableView.reloadData()
        }
        
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        likes = [String](repeating: "like", count: socialList.count)
        return socialList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let s = socialList[(indexPath as IndexPath).row]
        hint = s.socialId
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainListCell", for: indexPath)
            as! UserSocialMainListTableViewCell
        
        let s = socialList[(indexPath as IndexPath).row]
        cell.dateLbl.text = s.postedDateTime
        if(s.uploaderUsername == nil){
            cell.usernameLbl.text = s.uploader
        }else{
            cell.usernameLbl.text = s.uploaderUsername
        }
        cell.captionLbl.text = s.caption
        
        cell.hintLbl.text = s.socialId

        cell.btnLike.tag = indexPath.row
        cell.btnLike.addTarget(self, action: #selector(handleLikes(sender:)), for: .touchUpInside)
        
        cell.btnLike.setTitle(likes[(indexPath as IndexPath).row], for: UIControlState.normal)
        cell.btnLike.setImage(UIImage(named:"Like.png"), for: .normal)
        
        
        UserSocialDM.countTotalLikesForPhoto(socialId: s.socialId, onComplete: {(list) in
            cell.noOfLikes.text = String(list.isLike)
        })
        
        UserSocialProfileMasterViewController.loadImage(imageView: cell.mainListImageView, url: s.photoUrl!)
        
        return cell
    }

    func handleLikes(sender: AnyObject){
//        print("hint - \(hint)")
//        sender.setImage(UIImage(named: "LikeFilled.png")! as UIImage, for: .normal)

        UserSocialDM.updateNoOfPhotoLikes(
            socialId: hint,
            currentUserId: (GlobalDM.CurrentUser?.userId)!)
        
        
        print("sender.tag - \(sender.tag!)") // This works, every cell returns a different number and in order.
        if likes[sender.tag] == "like" {
            likes[sender.tag] = "unlike"
            print("unlike")
            sender.setImage(UIImage(named:"Like.png"), for: .normal)
        }
        else {
            likes[sender.tag] = "like"
            print("like")
            sender.setImage(UIImage(named:"LikeFilled.png"), for: .normal)
        }
        sender.setTitle(likes[sender.tag], for: UIControlState.normal)
        
    }
    
//    func handleLikes(sender: AnyObject){
//        print("sender.tag - \(sender.tag!)") // This works, every cell returns a different number and in order.
//    
//        if likes[sender.tag] == "like" {
//            likes[sender.tag] = "unlike"
//            sender.setImage(UIImage(named:"Like.png"), for: .normal)
//            
//            print("unlike")
//        }
//        else {
//            likes[sender.tag] = "like"
//            sender.setImage(UIImage(named:"LikeFilled.png"), for: .normal)
//            
//            print("like")
//        }
//        
//        UserSocialDM.updateNoOfPhotoLikes(
//            eventId: hint,
//            currentUserId: (GlobalDM.CurrentUser?.userId)!)
//    }
    

    
    @IBAction func actionSheetButtonPressed(sender: UIButton) {
        let alertController = UIAlertController(title: "Wanna report this post?", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Enter Flagged Reason"
            
            let reportAction = UIAlertAction(title: "Inappropriate / Irrelevant Post", style: .destructive) { action in
                print("ok")
            }
            alertController.addAction(reportAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                print("cancel")
            }
            alertController.addAction(cancelAction)
            
            let postAction = UIAlertAction(title: "Submit Reason", style: .destructive) { action in
                print("ok")
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
