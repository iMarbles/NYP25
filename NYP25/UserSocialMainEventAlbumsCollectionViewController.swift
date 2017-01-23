//
//  UserSocialMainEventAlbumsCollectionViewController.swift
//  NYP25
//
//  Created by Evelyn Tan on 23/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit

private let reuseIdentifier = "AlbumViewCell"

class UserSocialMainEventAlbumsCollectionViewController:  UICollectionViewController, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate {
    
    var event : Event?
    var eventAlbums : [Event] = []
    
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadPhotos()
        
        self.automaticallyAdjustsScrollViewInsets = true;
    }
    
    func loadPhotos(){
        UserSocialDM.retrieveEventAlbumCover(onComplete: { (albumCover) in
            self.eventAlbums = albumCover
            self.collectionView?.reloadData()
            
            if(self.eventAlbums.count == 0){
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
        return eventAlbums.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumViewCell", for: indexPath) as! UserSocialMainEventAlbumsCollectionViewCell
        
        let e = eventAlbums[(indexPath as IndexPath).row]
        
        cell.albumTitle.text = e.name
        
        loadAlbumCovers(imageView: cell.albumPhoto, url: e.imageUrl!)
        
//        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
//        let blurEffectView = UIVisualEffectView(effect: blurEffect)
//        blurEffectView.frame = view.bounds
//        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        cell.albumPhoto.addSubview(blurEffectView)
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate protocol
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        selectedRow = indexPath.row
        print("You selected cell \(eventAlbums[selectedRow].name!) !")
    }
    
    func loadAlbumCovers(imageView: UIImageView, url: String)
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
