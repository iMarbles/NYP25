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

    override func viewDidLoad() {
        super.viewDidLoad()

        
        loadSocial()
    }
    
    func loadSocial(){

        UserSocialDM.retrieveAllSocial{(dbList) in
            self.socialList = dbList
            self.tableView.reloadData()
        }
    }

    @IBAction func actionSheetButtonPressed(sender: UIButton) {
        let alertController = UIAlertController(title: "Need any help?", message: "(else select cancel option)", preferredStyle: .alert)
        
        alertController.addTextField { textField in
            textField.placeholder = "Description"
            
            let reportAction = UIAlertAction(title: "Inappropriate / Irrelevant Post", style: .default) { action in
                print("ok")
            }
            alertController.addAction(reportAction)

//            let destroyAction = UIAlertAction(title: "Delete Post", style: .destructive) { action in
//                //            print(action)
//                print("destroy")
//            }
//            alertController.addAction(destroyAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
                print("cancel")
            }
            alertController.addAction(cancelAction)
            
            let loginAction = UIAlertAction(title: "Description", style: .default) { [weak alertController] _ in
                textField.isEnabled = true
            }
            
            alertController.addAction(loginAction)
            
            let postAction = UIAlertAction(title: "Submit Post", style: .default) { action in
                print("ok")
            }
            alertController.addAction(postAction)
            postAction.isEnabled = false
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.UITextFieldTextDidChange, object: textField, queue: OperationQueue.main) { notification in
                postAction.isEnabled = true
            }
        }
    
        self.present(alertController, animated: true) {}

        
        /*
        let alertController = UIAlertController(title: nil, message: "Takes the appearance of the bottom bar if specified; otherwise, same as UIActionSheetStyleDefault.", preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            print("cancel")
        }
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { action in
            print("ok")
        }
        alertController.addAction(OKAction)
        
        let destroyAction = UIAlertAction(title: "Destroy", style: .destructive) { action in
//            print(action)
            print("destroy")
        }
        alertController.addAction(destroyAction)
        
        self.present(alertController, animated: true) {
            // ...
        }
        */
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
        var cell = tableView.dequeueReusableCell(withIdentifier: "mainListCell", for: indexPath)
            as! UserSocialMainListTableViewCell

        let s = socialList[(indexPath as IndexPath).row]

        cell.dateLbl.text = s.postedDateTime
        cell.usernameLbl.text = s.uploader
        cell.captionLbl.text = s.caption
        
        loadSocialImage(imageView: cell.mainListImageView, url: s.photoUrl!)
        
        return cell
     }
    
    func loadSocialImage(imageView: UIImageView, url: String)
    {
        DispatchQueue.global(qos: .background).async
            {
                let nurl = URL(string: url)
                var imageBinary : Data?
                if nurl != nil
                {
                    do
                    {
                        imageBinary = try Data(contentsOf: nurl!)
                    }
                    catch
                    {
                        return
                    }
                }
                
                DispatchQueue.main.async
                    {
                        var img : UIImage?
                        if imageBinary != nil
                        {
                            img = UIImage(data: imageBinary!)
                        }
                        
                        imageView.image = img
                        
                }
                
        }
    }
}
