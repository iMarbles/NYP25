//
//  AdminEventsGalleryCommentsViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 24/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class AdminEventsGalleryCommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var photoLikes: [PhotoLike] = []
    var commentsList : [PhotoComment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        for like in photoLikes{
            if like.comments != nil{
                for comment in like.comments!{
                    commentsList.append(comment)
                }
            }
            
        }
        
        commentsList.sort { (a, b) -> Bool in
            if a.timestamp != nil && b.timestamp != nil{
                if a.timestamp! > b.timestamp!{
                    return true
                }else{
                    return false
                }
            }else{
                return true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell")! as UITableViewCell
        
        cell.textLabel?.text = commentsList[(indexPath as IndexPath).row].username
        cell.detailTextLabel?.text = commentsList[(indexPath as IndexPath).row].comment
        
        return cell
    }
    
    @IBAction func backBtnPressed(sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
