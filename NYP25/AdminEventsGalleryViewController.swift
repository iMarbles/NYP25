//
//  AdminEventsGalleryViewController.swift
//  NYP25
//
//  Created by Zhen Wei on 28/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class AdminEventsGalleryViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var noLbl : UILabel!
    
    var event : Event?
    var eventPhotos : [Social] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadPhotos()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadPhotos(){
        AdminEventDM.retrieveEventPhotos(eventId: (event?.eventId)!, onComplete: { (photos) in
            self.eventPhotos = []
            for photo in photos{
                if photo.isFlagged != 3{
                    self.eventPhotos.append(photo)
                }
            }
            
            if(self.eventPhotos.count == 0){
                //Show nothing
                self.noLbl.isHidden = false
            }else{
                self.sortPhotosByDateTime()
                self.collectionView?.reloadData()
            }
        })
    }
    
    func sortPhotosByDateTime(){
        eventPhotos.sort { (a, b) -> Bool in
            if a.postedDateTime! > b.postedDateTime!{
                return true
            }else{
                return false
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return eventPhotos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! AdminEventGalleryCollectionViewCell
        cell.eventImage.image = UIImage(named: "loading-512")

        GlobalDM.loadImage(imageView: cell.eventImage, url: eventPhotos[(indexPath as IndexPath).row].photoUrl!)
            return cell
    }
    
    let itemsPerRow: CGFloat = 3
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
   
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "GalleryDetails"{
            let vc = segue.destination as! AdminEventsGalleryDetailsViewController
            
            let cell = sender as? AdminEventGalleryCollectionViewCell
            let indexPath = collectionView?.indexPath(for: cell!)
            
            vc.currentPhoto = eventPhotos[(indexPath?.row)!]
        }
    }
    
}
