//
//  UserSocialDM.swift
//  NYP25
//
//  Created by Evelyn Tan on 13/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class UserSocialDM: NSObject {
    
/*      START OF SELECT/RETRIEVE FUNCTIONS     */
    //Retrieve current user info
    static func retrieveAllUserInfo(userId : String, onComplete: @escaping (Student)->Void){
        let ref = FIRDatabase.database().reference().child("users/\(userId)/")
        
        ref.observeSingleEvent(of: .value, with:
            { (snapshot) in
                let s = Student()
                
                s.userId = snapshot.key
                s.username = (snapshot.childSnapshot(forPath: "username").value as? String)!
                s.displayPhotoUrl = snapshot.childSnapshot(forPath: "displayPhotoUrl").value as? String
                s.bio = snapshot.childSnapshot(forPath: "bio").value as? String
                s.name = (snapshot.childSnapshot(forPath: "name").value as? String)!
                s.password = (snapshot.childSnapshot(forPath: "password").value as? String)!
                s.points = (snapshot.childSnapshot(forPath: "points").value as? Int)!
                s.school = (snapshot.childSnapshot(forPath: "school").value as? String)!
                
                onComplete(s)
        })
    }
    
    //Retrieve all events
    static func retrieveAllSocialBySocialID(socialId : String, onComplete: @escaping ([PhotoLike])->Void){
        var likedByList : [PhotoLike] = []
        var commentList : [PhotoComment] = []
        
        let ref = FIRDatabase.database().reference().child("social/\(socialId)/likedBy/")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            likedByList = []
            
            for record in snapshot.children{
                let r = record as! FIRDataSnapshot
                
                let p = PhotoLike()
                p.adminNo = r.key
                p.isLike = (r.childSnapshot(forPath: "isLiked").value as? Int)!
                
                //Child nodes
                commentList = []
                let comments = r.childSnapshot(forPath: "comments").children
                for commented in comments{
                    let c = commented as! FIRDataSnapshot
                    
                    let pc = PhotoComment()
                    pc.commentId = c.key
                    pc.username = c.childSnapshot(forPath: "username").value as! String
                    pc.timestamp = c.childSnapshot(forPath: "timestamp").value as! String
                    pc.comment = c.childSnapshot(forPath: "comment").value as! String
                    
                    commentList.append(pc)
                }
                
                p.comments = commentList
                likedByList.append(p)
            }
            
            
            onComplete(likedByList)
        })
    }
    
    static func retrieveAllPhotosForLikeCount(socialId : String, onComplete: @escaping ([PhotoLike])->Void){
        var likedByList : [PhotoLike] = []
        
        let ref = FIRDatabase.database().reference().child("social/\(socialId)/likedBy/")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            likedByList = []
            
            for record in snapshot.children{
                let r = record as! FIRDataSnapshot
                
                let p = PhotoLike()
                p.adminNo = r.key
                p.isLike = (r.childSnapshot(forPath: "isLiked").value as? Int)!
                
                if(p.isLike == 1){
                    likedByList.append(p)
                }
            }
            
            onComplete(likedByList)
        })
    }
    
    static func retrieveAllPhotosForCommentCount(socialId : String, onComplete: @escaping ([PhotoLike])->Void){
        var likedByList : [PhotoLike] = []
        var commentList : [PhotoComment] = []
        
        let ref = FIRDatabase.database().reference().child("social/\(socialId)/likedBy/")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            likedByList = []
            
            for record in snapshot.children{
                let r = record as! FIRDataSnapshot
                
                let p = PhotoLike()
                p.adminNo = r.key
                p.isLike = (r.childSnapshot(forPath: "isLiked").value as? Int)!
                
                //Child nodes
                commentList = []
                let comments = r.childSnapshot(forPath: "comments").children
                for commented in comments{
                    let c = commented as! FIRDataSnapshot
                    
                    let pc = PhotoComment()
                    pc.commentId = c.key
                    pc.username = c.childSnapshot(forPath: "username").value as! String
                    pc.timestamp = c.childSnapshot(forPath: "timestamp").value as! String
                    pc.comment = c.childSnapshot(forPath: "comment").value as! String
                    
                    commentList.append(pc)
                    
                    p.comments = commentList
                    likedByList.append(p)
                }
            }
            onComplete(likedByList)
        })
    }
    
    
    //Retrieve all events
    static func retrieveAllSocial(onComplete: @escaping ([Social])->Void){
        var socialList : [Social] = []
        var likedByList : [PhotoLike] = []
        var commentList : [PhotoComment] = []
        
        let ref = FIRDatabase.database().reference().child("social/").queryOrdered(byChild: "postedDateTime")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            socialList = []
            
            //.reversed() - for descending order
            for record in snapshot.children.reversed(){
                let r = record as! FIRDataSnapshot
                
                let s = Social()
                
                s.socialId = r.key
                s.eventId = r.childSnapshot(forPath: "eventId").value as! String
                s.photoUrl = r.childSnapshot(forPath: "photoUrl").value as? String
                s.uploader = r.childSnapshot(forPath: "uploader").value as? String
                s.caption = r.childSnapshot(forPath: "caption").value as? String
                s.postedDateTime = r.childSnapshot(forPath: "postedDateTime").value as? String
                s.isFlagged = (r.childSnapshot(forPath: "isFlagged").value as? Int)!
                s.flagReason = r.childSnapshot(forPath: "flagReason").value as? String
                s.uploaderUsername = r.childSnapshot(forPath: "uploaderUsername").value as? String
                
                //Child nodes
                likedByList = []
                let likes = r.childSnapshot(forPath: "likedBy").children
                for liked in likes{
                    let l = liked as! FIRDataSnapshot
                    
                    let p = PhotoLike()
                    p.adminNo = l.key
                    p.isLike = (l.childSnapshot(forPath: "isLiked").value as? Int)!
                    
                    //Child nodes
                    commentList = []
                    let comments = l.childSnapshot(forPath: "comments").children
                    for commented in comments{
                        let c = commented as! FIRDataSnapshot
                        
                        let pc = PhotoComment()
                        pc.commentId = c.key
                        pc.username = c.childSnapshot(forPath: "username").value as! String
                        pc.timestamp = c.childSnapshot(forPath: "timestamp").value as? String
                        pc.comment = c.childSnapshot(forPath: "comment").value as! String
                        
                        commentList.append(pc)
                    }

                    p.comments = commentList
                    likedByList.append(p)
                }
                
                if(s.isFlagged == 0){
                    s.likes = likedByList
                    socialList.append(s)
                }
            }
            
            onComplete(socialList)
        })
    }
    
    //Retrieve all events
    static func retrieveAllSocialByID(socialId : String, onComplete: @escaping ([Social])->Void){
        var socialList : [Social] = []
        var likedByList : [PhotoLike] = []
        var commentList : [PhotoComment] = []
        
        let ref = FIRDatabase.database().reference().child("social/").queryOrdered(byChild: "postedDateTime")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            socialList = []
            
            //.reversed() - for descending order
            for record in snapshot.children.reversed(){
                let r = record as! FIRDataSnapshot
                
                let s = Social()
                
                s.socialId = r.key
                s.eventId = r.childSnapshot(forPath: "eventId").value as! String
                s.photoUrl = r.childSnapshot(forPath: "photoUrl").value as? String
                s.uploader = r.childSnapshot(forPath: "uploader").value as? String
                s.caption = r.childSnapshot(forPath: "caption").value as? String
                s.postedDateTime = r.childSnapshot(forPath: "postedDateTime").value as? String
                s.isFlagged = (r.childSnapshot(forPath: "isFlagged").value as? Int)!
                s.flagReason = r.childSnapshot(forPath: "flagReason").value as? String
                s.uploaderUsername = r.childSnapshot(forPath: "uploaderUsername").value as? String
                
                //Child nodes
                likedByList = []
                let likes = r.childSnapshot(forPath: "likedBy").children
                for liked in likes{
                    let l = liked as! FIRDataSnapshot
                    
                    let p = PhotoLike()
                    p.adminNo = l.key
                    p.isLike = (l.childSnapshot(forPath: "isLiked").value as? Int)!
                    
                    //Child nodes
                    commentList = []
                    let comments = l.childSnapshot(forPath: "comments").children
                    for commented in comments{
                        let c = commented as! FIRDataSnapshot
                        
                        let pc = PhotoComment()
                        pc.commentId = c.key
                        pc.username = c.childSnapshot(forPath: "username").value as! String
                        pc.timestamp = c.childSnapshot(forPath: "timestamp").value as? String
                        pc.comment = c.childSnapshot(forPath: "comment").value as! String
                        
                        commentList.append(pc)
                    }
                    
                    p.comments = commentList
                    likedByList.append(p)
                }
                
                if(s.isFlagged == 0){
                    s.likes = likedByList
                    socialList.append(s)
                }
            }
            
            onComplete(socialList)
        })
    }

    
    //COUNT TOTAL AMOUNT OF LIKES FOR THE PHOTO
    static func countTotalLikesForPhoto(socialId : String, onComplete: @escaping (PhotoLike)->Void){
        let refLikedBy = FIRDatabase.database().reference().child("social/\(socialId)/likedBy/")
        
        var count = 0
        refLikedBy.observe(.value, with: { (snapshot: FIRDataSnapshot!) in
            count += Int(snapshot.childrenCount)
            
            let p = PhotoLike()
            p.isLike = count
            
            onComplete(p)
        })
    }
    
//    //COUNT TOTAL AMOUNT OF COMMENTS FOR THE PHOTO
//    static func countTotalCommentsForPhoto(userId : String, socialId : String, onComplete: @escaping (PhotoComment)->Void){
//        let refLikedBy = FIRDatabase.database().reference().child("social/\(socialId)/likedBy/\(userId)/comments/")
//        
//        var count = 0
//        refLikedBy.observe(.value, with: { (snapshot: FIRDataSnapshot!) in
//            count += Int(snapshot.childrenCount)
//            
//            let pc = PhotoComment()
//            pc.commentId = String(count)
//            
//            onComplete(pc)
//        })
//    }
    
    //COUNT TOTAL SOCIAL POST
    static func countTotalSocialPost(onComplete: @escaping (Social)->Void){
        let ref = FIRDatabase.database().reference().child("social/")
        
        var count = 0
        ref.observe(.value, with: { (snapshot: FIRDataSnapshot!) in
            count += Int(snapshot.childrenCount)
            
            let s = Social()
            s.eventId = String(count)
            
            onComplete(s)
        })
    }
    
    //Retrieve all social album
    static func retrieveAllSocialAlbum(onComplete: @escaping ([Social])->Void){
        var socialList : [Social] = []
        
        let ref = FIRDatabase.database().reference().child("social/")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            socialList = []
            
            for record in snapshot.children{
                let r = record as! FIRDataSnapshot
                
                let s = Social()
                
                s.socialId = r.key
                s.uploader = r.childSnapshot(forPath: "uploader").value as? String
                s.photoUrl = r.childSnapshot(forPath: "photoUrl").value as? String
                
                socialList.append(s)
            }
            
            onComplete(socialList)
        })
    }
    
    //Retrieve event names
    static func retrieveEventNames(onComplete: @escaping ([Event])->Void){
        var eventNames : [Event] = []
        
        let ref = FIRDatabase.database().reference().child("events/")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            eventNames = []
            
            for record in snapshot.children{
                let r = record as! FIRDataSnapshot
                
                let e = Event()
                e.eventId = r.key
                e.name = r.childSnapshot(forPath: "name").value as? String
                e.address = r.childSnapshot(forPath: "address").value as? String
                e.imageUrl = r.childSnapshot(forPath: "image").value as? String
                e.badgeId = r.childSnapshot(forPath: "badge").value as? String
                e.desc = r.childSnapshot(forPath: "description").value as? String
                e.date = r.childSnapshot(forPath: "date").value as? String
                e.startTime = r.childSnapshot(forPath: "startTime").value as? String
                e.endTime = r.childSnapshot(forPath: "endTime").value as? String
                e.status = r.childSnapshot(forPath: "status").value as! String
                
                
                if(e.status == "O"){
                    eventNames.append(e)
                }
                
                onComplete(eventNames)
            }
        })
    }

    //Retrieve all images of event
    static func retrieveEventPhotosByID(eventId : String, onComplete: @escaping ([Social])->Void){
        var socialPhotos : [Social] = []
        
        let ref = FIRDatabase.database().reference().child("social/\(eventId)/")
        
        ref.observeSingleEvent(of: .value, with:
            {(snapshot) in
                for record in snapshot.children{
                    let r = record as! FIRDataSnapshot
                    
                    let photo = Social()
                    photo.eventId = r.childSnapshot(forPath: "eventId").value as! String
                    photo.photoUrl = r.childSnapshot(forPath: "photoUrl").value as? String
                    
                    socialPhotos.append(photo)
                    
                    onComplete(socialPhotos)
                }
        })
    }

    
    //Retrieve all images of event
    static func retrieveEventPhotos(onComplete: @escaping ([Social])->Void){
        var socialPhotos : [Social] = []
        
        let ref = FIRDatabase.database().reference().child("social/")
        
        ref.observeSingleEvent(of: .value, with:
            {(snapshot) in
                for record in snapshot.children{
                    let r = record as! FIRDataSnapshot
                    
                    let photo = Social()
                    photo.eventId = r.childSnapshot(forPath: "eventId").value as! String
                    photo.photoUrl = r.childSnapshot(forPath: "photoUrl").value as? String
                    
                    socialPhotos.append(photo)
                    
                    onComplete(socialPhotos)
                }
        })
    }
    
    //Retrieve all images of event
    static func retrieveEventPhotosByEventId(eventId : String, onComplete: @escaping ([Social])->Void){
        var socialPhotos : [Social] = []
        
        let ref = FIRDatabase.database().reference().child("social/")
        
        ref.observeSingleEvent(of: .value, with:
            {(snapshot) in
                for record in snapshot.children{
                    let r = record as! FIRDataSnapshot
                    
                    let photo = Social()
                    photo.eventId = r.childSnapshot(forPath: "eventId").value as! String
                    photo.photoUrl = r.childSnapshot(forPath: "photoUrl").value as? String
                    
                    if(photo.eventId == eventId){
                        socialPhotos.append(photo)   
                    }
                    
                    onComplete(socialPhotos)
                }
        })
    }

    //Retrieve all images of event by ID
    static func retrieveEventAlbumCover(onComplete: @escaping ([Event])->Void){
        var albumCover : [Event] = []
        
        let ref = FIRDatabase.database().reference().child("events/")
        
        ref.observeSingleEvent(of: .value, with:
            {(snapshot) in
                for record in snapshot.children{
                    let r = record as! FIRDataSnapshot
                    
                    let e = Event()
                    e.name = r.childSnapshot(forPath: "name").value as? String
                    e.imageUrl = r.childSnapshot(forPath: "image").value as? String
                    //To add-on as needed
                    
                    albumCover.append(e)
                    
                    onComplete(albumCover)
                }
        })
    }

/*      END OF SELECT/RETRIEVE FUNCTIONS     */
    
/*      START OF CREATE FUNCTIONS     */
    static func createPost(eventId : String, social : Social, socialPhotos : NSData?, currentUserId : String, uploaderUsername : String){
        let key = FIRDatabase.database().reference().child("social").childByAutoId().key
        let ref = FIRDatabase.database().reference().child("social/\(key)/")
        let storage = FIRStorage.storage().reference().child("/SocialPhoto/\(key)/")
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let currentDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd, HH:mm"
        
        let result = dateFormatter.string(from: currentDate as Date)
        
        storage.put(socialPhotos as! Data, metadata: metadata){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                
                //store downloadURL at database
                ref.setValue([
                    "caption" : social.caption!,
                    "uploader" : social.uploader!,
                    "postedDateTime" : result,
                    "isFlagged" : social.isFlagged,
                    "flagReason" : social.flagReason!,
                    "photoUrl" : downloadURL,
                    "eventId" : social.eventId,
                    "uploaderUsername" : uploaderUsername
                    ])
                
//                refLikedBy.setValue([
//                    "isLiked" : likedBy.isLike
//                    ])
//                
//                refComments.setValue([
//                    "comment" : comments.comment,
//                    "postedDateTime" : comments.timestamp,
//                    "username" : comments.username
//                    ])
            }
        }
    }
/*      END OF CREATE FUNCTIONS     */
    
/*      START OF UPDATE FUNCTIONS     */
    static func reportPhoto(socialId : String, currentUserId : String, flagReason : String){
        let refLikedBy = FIRDatabase.database().reference().child("social/\(socialId)/")
        
        refLikedBy.updateChildValues([
            "isFlagged" : 1,
            "flagReason" : flagReason
            ])
    }

    static func updateNoOfPhotoLikes(socialId : String, currentUserId : String){
        print(socialId)
        let refLikedBy = FIRDatabase.database().reference().child("social/\(socialId)/likedBy/\(currentUserId)/")
        
        refLikedBy.observeSingleEvent(of: .value, with:
            { (snapshot) in
                
                let p = PhotoLike()
                
                p.adminNo = snapshot.key
                
                print("p.adminNo : \(p.adminNo)")
                print("currentUserId : \(currentUserId)")
                
                if (snapshot.childSnapshot(forPath: "isLiked").value is NSNull ) {
                    p.isLike = 1
                    
                    refLikedBy.updateChildValues([
                        "isLiked" : p.isLike
                        ])
                }else {
                    if(p.adminNo != currentUserId){     //like photo
                        //Create the like record
                        p.isLike = 1
                        print("liked")
                        
                        refLikedBy.updateChildValues([
                            "isLiked" : p.isLike
                            ])
                        
                    }else if(p.adminNo == currentUserId) {  //unlike photo
                        p.isLike = (snapshot.childSnapshot(forPath: "isLiked").value as? Int)!
                        
                        print("p.isLike - \(p.isLike)")
                        
                        if(p.isLike == 1){
                            //Delete record
                            refLikedBy.removeValue()
                        }
                    }
                    
                }
        })
    }
/*      END OF UPDATE FUNCTIONS     */

/*      START OF DELETE FUNCTIONS     */
    
/*      END OF DELETE FUNCTIONS     */
}
