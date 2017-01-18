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
