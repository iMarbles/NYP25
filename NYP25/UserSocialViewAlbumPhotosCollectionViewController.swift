//
//  UserSocialViewAlbumPhotosCollectionViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 2/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

class UserSocialViewAlbumPhotosCollectionViewController: UICollectionViewController {

    var eventInfo : Event?
    
    var eventAlbum : [Social] = []
    var soloEventAlbum : [Social] = []
    
    var eventIdLbl : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        layout.itemSize = CGSize(width: width / 2, height: width / 2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionView?.collectionViewLayout = layout
        
        print("eventIdLbl - \(eventIdLbl)")
        
        UserSocialDM.retrieveEventPhotosByEventId(eventId : eventIdLbl, onComplete: { (list) in
            self.eventAlbum = list
            self.collectionView?.reloadData()
            
            for a in self.eventAlbum{
                print("a.eventId - \(a.eventId)")
                print("eventIdLbl - \(self.eventIdLbl)")
                self.soloEventAlbum.append(a)
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return soloEventAlbum.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "soloAlbumCell", for: indexPath) as! UserSocialViewAlbumPhotosCollectionViewCell
        
        cell.albumPhoto?.image = UIImage(named: "loading-512")
        
        UserSocialProfileMasterViewController.loadImage(imageView: cell.albumPhoto, url: soloEventAlbum[(indexPath as IndexPath).row].photoUrl!)
        
        return cell
    }
}
