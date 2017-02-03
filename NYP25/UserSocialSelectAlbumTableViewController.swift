//
//  UserSocialSelectAlbumTableViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 3/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialSelectAlbumTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var eventNameList : [Event] = []
    var albumPhotos : [Social] = []
    var countAlbumPhotos : [Social] = []
    
    @IBOutlet var btnNext : UIBarButtonItem?
    var albumSelected : String = ""

    var selectedImage: UIImageView!
    var socialImg : Social? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserSocialDM.retrieveEventNames(onComplete: { (nameList) in
            self.eventNameList = nameList
            self.tableView.reloadData()
            
            self.eventNameList.sort { (a, b) -> Bool in
                if a.date! > b.date!{
                    return true
                }else{
                    return false
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
        return eventNameList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "SelectAlbumTableCell", for: indexPath)
            as! UserSocialSelectAlbumTableViewCell
        
        cell.socialPhotoView?.image = UIImage(named: "loading-512")
        
        let s = eventNameList[(indexPath as IndexPath).row]
        cell.eventNameLbl.text = s.name
        cell.eventDateLbl.text = GlobalDM.getDateNameBy(stringDate: s.date!)
        
        UserSocialDM.retrieveEventPhotos(onComplete: {(list) in
            self.albumPhotos = list
        })
        
        for a in self.albumPhotos{
            print("a.eventId - \(a.eventId)")
            self.countAlbumPhotos.append(a)
        }
        
//        cell.totalNoOfPhotosLbl.text = String(self.countAlbumPhotos.count)
        
        UserSocialProfileMasterViewController.loadImage(imageView: cell.socialPhotoView, url: eventNameList[(indexPath as IndexPath).row].imageUrl!)
        
        albumSelected = eventNameList[(indexPath as IndexPath).row].eventId
        print("albumSelected in cellForRowAt - \(albumSelected)")

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var cell = tableView.cellForRow(at: indexPath as IndexPath)
        btnNext?.isEnabled = true
    
        albumSelected = eventNameList[(indexPath as IndexPath).row].eventId
        print("albumSelected - \(albumSelected)")
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        var cell = tableView.cellForRow(at: indexPath as IndexPath)
//        cell?.layer.borderWidth = 2.0
//        cell?.layer.borderColor = UIColor.clear.cgColor
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToUploadPhoto" {
            let a = segue.destination as! UserSocialSelectImageViewController
            a.selectedId = albumSelected
        }
    }
}
