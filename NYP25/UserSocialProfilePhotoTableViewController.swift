//
//  UserSocialProfilePhotoTableViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 18/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialProfilePhotoTableViewController: UITableViewController {

    var userList : [Student] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserSocialDM.retrieveUserProfilePhoto(onComplete: {(dbList) in
            self.userList = dbList
            self.tableView.reloadData()
        })
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return userList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "profilePhotoCell", for: indexPath)
            as! UserSocialProfilePhotoTableViewCell
        
        let s = userList[(indexPath as IndexPath).row]
        
        cell.usernameLbl.text = GlobalDM.CurrentUser!.userId

        loadSocialImage(imageView: cell.profilePhotoView, url: s.displayPhotoUrl!)
        
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
