//
//  UserProfileViewLikedPhotosCollectionViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 21/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

//private let reuseIdentifier = "Cell"

class UserProfileViewLikedPhotosCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var profileGallery : [Social] = []
    var likedPhotos : [Social] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        UserSocialDM.retrieveEventPhotos(onComplete: { (photos) in
//            self.profileGallery = photos
//            self.collectionView?.reloadData()
//            
//            if(self.profileGallery.count == 0){
//                let alert = UIAlertView(title: "",
//                                        message: "No Photos Available Currently",
//                                        delegate: nil,
//                                        cancelButtonTitle: "Ok")
//                alert.show()
//                
//            }
//        })
        
        UserSocialDM.retrieveAllSocial(onComplete: { (p) in
            self.likedPhotos = p
            self.collectionView?.reloadData()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profileGallery.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedPhotosCell", for: indexPath) as! UserProfileViewLikedPhotosCollectionViewCell
        
        let path = likedPhotos[(indexPath as IndexPath).row]
        
        UserSocialDM.retrieveAllUserLikedPhotos(eventId: path.eventId, userId: (GlobalDM.CurrentUser?.userId)!, onComplete: {(liked) in
            self.loadGallery(imageView: cell.likedPhotos, url: self.likedPhotos[(indexPath as IndexPath).row].photoUrl!)
        })
        
//        let s = socialList[(indexPath as IndexPath).row]
//        cell.dateLbl.text = s.postedDateTime
//        cell.usernameLbl.text = s.uploaderUsername
//        cell.captionLbl.text = s.caption
//        
//        UserSocialDM.retrieveNoOfTotalLikesForPhotos(eventId: s.eventId, onComplete: {(list) in
//            cell.noOfLikes.text = String(list.isLike)
//        })
//
//        print(s.eventId)
//        
//        if cell.buttonDelegate == nil {
//            cell.buttonDelegate = self
//        }
//        
//        loadSocialImage(imageView: cell.mainListImageView, url: s.photoUrl!)
        
        
        
//        loadGallery(imageView: cell.likedPhotos, url: profileGallery[(indexPath as IndexPath).row].photoUrl!)
        return cell
    }
    
    func loadGallery(imageView: UIImageView, url: String)
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
    }}
