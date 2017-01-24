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
    
//    static func createPost(eventId : String, social : Social, socialPhotos : NSData?, likedBy : PhotoLike, currentUserId : String, comments : PhotoComment){
    static func createPost(eventId : String, social : Social, socialPhotos : NSData?, currentUserId : String){
        let key = FIRDatabase.database().reference().child("social").childByAutoId().key
        let ref = FIRDatabase.database().reference().child("social/\(key)/")
        let storage = FIRStorage.storage().reference().child("/SocialPhoto/\(eventId)/")
        
//        let refLikedBy = FIRDatabase.database().reference().child("social/\(key)/likedBy/\(currentUserId)/")
//        let refComments = FIRDatabase.database().reference().child("social/\(key)/likedBy/\(currentUserId)/comments/\(key)/")
        
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
                    "eventId" : social.eventId
                    ])
                
//                refLikedBy.setValue([
//                    "isLiked" : likedBy.isLike
//                    ])
                
//                refComments.setValue([
//                    "comment" : comments.comment,
//                    "postedDateTime" : comments.timestamp,
//                    "username" : comments.username
//                    ])
            }
        }
    }

//    //Retrieve current user info
//    static func retrieveAllUserInfo(userId : String, onComplete: @escaping (Student)->Void){
//        var studentList : [Student] = []
//
//        let ref = FIRDatabase.database().reference().child("users/\(userId)/")
//
//        ref.observe(FIRDataEventType.value, with:{
//            (snapshot) in
//                studentList = []
//
//            for record in snapshot.children.reversed(){
//                let r = record as! FIRDataSnapshot
//                
//                let s = Student()
//                
//                    s.userId = r.key
//                    s.username = (r.childSnapshot(forPath: "username").value as? String)!
//                    s.displayPhotoUrl = r.childSnapshot(forPath: "displayPhotoUrl").value as? String
//                    s.bio = r.childSnapshot(forPath: "bio").value as? String
//                    s.name = (r.childSnapshot(forPath: "name").value as? String)!
//                    s.password = (r.childSnapshot(forPath: "password").value as? String)!
//                    s.points = (r.childSnapshot(forPath: "points").value as? Int)!
//                    s.school = (r.childSnapshot(forPath: "school").value as? String)!
//                    
//                    studentList.append(s)
//            }
//            
//            onComplete(studentList)
//        })
//    }
    
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
    static func retrieveAllSocial(onComplete: @escaping ([Social])->Void){
        var socialList : [Social] = []
        var likedByList : [PhotoLike] = []
        
        let ref = FIRDatabase.database().reference().child("social/").queryOrdered(byChild: "postedDateTime")

        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            socialList = []
            
            //.reversed() - for descending order
            for record in snapshot.children.reversed(){
                let r = record as! FIRDataSnapshot
                
                let s = Social()
                
                s.eventId = r.key
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
                    
                    likedByList.append(p)
                }

                s.likes = likedByList
                socialList.append(s)
            }
            
            onComplete(socialList)
        })
    }
    
    static func updateNoOfPhotoLikes(eventId : String, currentUserId : String){
        let refLikedBy = FIRDatabase.database().reference().child("social/\(eventId)/likedBy/\(currentUserId)/")
        
        refLikedBy.observeSingleEvent(of: .value, with:
            { (snapshot) in

                let p = PhotoLike()
                
                p.adminNo = snapshot.key
                
                print("p.adminNo : \(p.adminNo)")
                print("currentUserId : \(currentUserId)")
                
                if (snapshot.childSnapshot(forPath: "isLiked").value is NSNull ) {
                    p.isLike = 1
                    
                    refLikedBy.setValue([
                        "isLiked" : p.isLike
                        ])
                }else {
                    if(p.adminNo != currentUserId){
                        //Create the like record
                        let num = p.isLike
                        p.isLike = 1
                        print("liked")
                        
                        refLikedBy.setValue([
                            "isLiked" : p.isLike
                            ])
                        
                    }else if(p.adminNo == currentUserId){ //problem now is - it works for the first time like, second time like is deleted
                        p.isLike = (snapshot.childSnapshot(forPath: "isLiked").value as? Int)!
                        
                        print("p.isLike - \(p.isLike)")
                        
                        if(p.isLike == 1){
                            //Delete record
                            print("here here")
                            
//                            let photoRef = FIRDatabase.database().reference().child("social/\(eventId)/likedBy/\(currentUserId)")
//                            photoRef.observe(.value, with: { (snapshot) -> Void in
                            
                                refLikedBy.removeValue()
                                
                                //                                ref.child("Users/\(uniqueUserID)").removeValue()
                                
                                
                                //                                if snapshot.exists(){
                                //                                    for item in snapshot.children {
                                //                                        (item as AnyObject).ref.child((item as AnyObject).key!).parent?.removeValue()
                                //                                    }
                                //                                }
//                            })
                        }
                    }
                }
            })
    }

    //Retrieve all events
    static func retrieveNoOfTotalLikesForPhotos(eventId : String, onComplete: @escaping (PhotoLike)->Void){
        let refLikedBy = FIRDatabase.database().reference().child("social/\(eventId)/likedBy/")
        
        var count = 0
        refLikedBy.observe(.value, with: { (snapshot: FIRDataSnapshot!) in
            count += Int(snapshot.childrenCount)
            
            let p = PhotoLike()
            p.isLike = count

            onComplete(p)
//            print("\(eventId) - \(count)")
            
        })
        
//        let refLikedBy = FIRDatabase.database().reference().child("social/\(eventId)/likedBy/")
//
//        var count = 0
//        refLikedBy.observe(.value, with: { (snapshot: FIRDataSnapshot!) in
//            count += Int(snapshot.childrenCount)
//            print("\(eventId) - \(count)")
//        })
        
        
//        FIRDatabase.database().reference().child("social/\(eventId)/likedBy").observeSingleEvent(of: .value, with: {(snap) in
//            let count = snap.value
//            print(count)
//        })
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
                
                s.eventId = r.key
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
                    
                    eventNames.append(e)
                    
                    onComplete(eventNames)
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
    
    //Retrieve all images of event
    static func retrieveEventPhotos(onComplete: @escaping ([Social])->Void){
        var socialPhotos : [Social] = []
        
        let ref = FIRDatabase.database().reference().child("social/")
        
        ref.observeSingleEvent(of: .value, with:
            {(snapshot) in
                for record in snapshot.children{
                    let r = record as! FIRDataSnapshot
                    
                    let photo = Social()
                    photo.photoUrl = r.childSnapshot(forPath: "photoUrl").value as? String
                    //To add-on as needed
                    
                    socialPhotos.append(photo)
                    
                    onComplete(socialPhotos)
                }
        })
    }
    
    //    static func createPost(social : Social, socialPhotos : NSData?){
    //        let key = FIRDatabase.database().reference().child("social").childByAutoId().key
    //        let ref = FIRDatabase.database().reference().child("social/\(key)/")
    //
    //        let currentDate = NSDate()
    //        let dateFormatter = DateFormatter()
    //        dateFormatter.dateFormat = "yyyyMMdd, HH:mm"
    //
    //        let result = dateFormatter.string(from: currentDate as Date)
    //
    //        ref.setValue([
    //            "caption" : social.caption!,
    //            "uploader" : social.uploader!,
    //            "postedDateTime" : result,
    //            "isFlagged" : social.isFlagged,
    //            "flagReason" : social.flagReason!
    //            ])
    //
    //        //        ref.setValue([ "caption" : "\(social.caption!)" ])
    //
    //        uploadEventImage(eventId: key, socialPhotos: socialPhotos!)
    //    }
    
    //    static func uploadEventImage(eventId : String, socialPhotos : NSData){
    //        let storage = FIRStorage.storage().reference().child("/SocialPhoto/\(eventId)/")
    //
    //        let metadata = FIRStorageMetadata()
    //        metadata.contentType = "image/jpeg"
    //
    //        storage.put(socialPhotos as Data, metadata: metadata){(metaData,error) in
    //            if let error = error {
    //                print(error.localizedDescription)
    //                return
    //            }else{
    //                //store downloadURL
    //                let downloadURL = metaData!.downloadURL()!.absoluteString
    //
    //                //store downloadURL at database
    //                FIRDatabase.database().reference().child("social/\(eventId)").updateChildValues(["photoUrl" : downloadURL])
    //            }
    //            
    //        }
    //    }
}









//                        let num = p.isLike
//                        p.isLike = 0

//                        static func removeLike(eventId : String, currentUserId : String){
//                            refLikedBy.child(currentUserId).removeValue { (error, ref) in
//                                if error != nil {
//                                    print("error \(error)")
//                                }
//                            }
