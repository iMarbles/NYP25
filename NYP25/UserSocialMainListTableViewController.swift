
//
//  UserSocialMainListTableViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 17/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialMainListTableViewController: UITableViewController {
    var likedBy : PhotoLike?
    var likes: [String]!

    var socialList : [Social] = []
    var countList : [PhotoLike] = []
    
    var imgToPass: Social?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        likedBy = PhotoLike()
        
        UserSocialDM.retrieveAllSocial{(dbList) in
            self.socialList = dbList
            self.tableView.reloadData()
            
            
            if(self.socialList.count == 0){
                print("no photo")
            }
        }

        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
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
        cell.dateLbl.text = GlobalDM.getCommentDateTimeBy(stringDate: s.postedDateTime!)
        
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
        
        cell.btnViewComments.tag = indexPath.row
        cell.btnViewComments.addTarget(self, action: #selector(actionViewComments), for: .touchUpInside)

        UserSocialProfileMasterViewController.loadImage(imageView: cell.mainListImageView, url: s.photoUrl!)
        
        UserSocialDM.retrieveAllPhotosForLikeCount(socialId: s.socialId, onComplete: {(list) in
            self.countList = list
            cell.countLikesLbl.text = String(self.countList.count)
            //self.tableView.reloadData()
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
        
        self.tableView.reloadData()
    }

    func actionViewComments(sender: AnyObject) {
        let vc = UIStoryboard(name:"UserSocial", bundle:nil).instantiateViewController(withIdentifier: "PhotoDetails") as! UserSocialPhotoDetailsViewController
        vc.socialImg = socialList[(sender.tag)]
        self.navigationController?.pushViewController(vc, animated:true)
    }

    
    func actionSheetButtonPressed(sender: AnyObject) {
        if((GlobalDM.CurrentUser?.userId)! != (socialList[sender.tag].uploader)!){
            print("(GlobalDM.CurrentUser?.userId)! - \(GlobalDM.CurrentUser?.userId)")
            print("(socialList[sender.tag].uploader)! - \(socialList[sender.tag].uploader)")
            
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
        }else{
            let alertController = UIAlertController(title: "You can't report your own photo!!", message: nil, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel) { action in
                print("Ok")
            }
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true) {}

        }
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
