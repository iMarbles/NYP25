//
//  UserSocialProfileLikedCollectionViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 18/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

private let reuseIdentifier = "likedPhotosCell"

class UserSocialProfileLikedCollectionViewController: UICollectionViewController , UICollectionViewDelegateFlowLayout {
    
    var social : Social?
    var socialPhotos : [Social] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPhotos()
        
//        self.automaticallyAdjustsScrollViewInsets = false
//        self.collectionView?.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0)

    }
    
    func loadPhotos(){
        UserSocialDM.retrieveEventPhotos(onComplete: { (photos) in
            self.socialPhotos = photos
            self.collectionView?.reloadData()
            
            if(self.socialPhotos.count == 0){
                let alert = UIAlertView(title: "",
                                        message: "No Photos Available Currently",
                                        delegate: nil,
                                        cancelButtonTitle: "Ok")
                alert.show()
                
            }
        })
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return socialPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedPhotosCell", for: indexPath) as! UserSocialProfileLikedCollectionViewCell
        
        UserSocialProfileMasterViewController.loadImage(imageView: cell.socialLikedImage, url: socialPhotos[(indexPath as IndexPath).row].photoUrl!)
        return cell
    }
}
