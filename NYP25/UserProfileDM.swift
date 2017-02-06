

//
//  UserProfileDM.swift
//  NYP25
//
//  Created by Evelyn Tan on 20/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class UserProfileDM: NSObject {
    
    //SHA256
    static func sha256(_ string: String) -> Data? {
        guard let messageData = string.data(using:String.Encoding.utf8) else { return nil; }
        var digestData = Data(count: Int(CC_SHA256_DIGEST_LENGTH))
        
        _ = digestData.withUnsafeMutableBytes {digestBytes in
            messageData.withUnsafeBytes {messageBytes in
                CC_SHA256(messageBytes, CC_LONG(messageData.count), digestBytes)
            }
        }
        return digestData
    }
    
    
    static func deletePhoto(socialId : String){
        let ref = FIRDatabase.database().reference().child("social/\(socialId)/")
        
        ref.removeValue()
    }

    static func updateProfileBio(currentUser : String, bio : String){
        let ref = FIRDatabase.database().reference().child("users/\(currentUser)/")
        
        ref.updateChildValues([
            "bio" : bio
            ])
    }
    
    static func updatePassword(currentUser : String, password : String){
        let shaData = sha256(password)
        let shaHex =  shaData!.map { String(format: "%02hhx", $0) }.joined()
        
        let ref = FIRDatabase.database().reference().child("users/\(currentUser)/")
        
        ref.updateChildValues([
            "password" : shaHex
            ])
    }
    
    static func updateCurrentSelectedBadge(badgeId: String, userId : String){
        let ref = FIRDatabase.database().reference().child("users/\(userId)/badges/\(badgeId)/")
        
        ref.updateChildValues([
            "isDisplay" : 0
            ])
    }
    
    
    static func updateNewSelectedBadge(badgeId: String, userId : String){
        let ref = FIRDatabase.database().reference().child("users/\(userId)/badges/\(badgeId)/")
        
        ref.updateChildValues([
            "isDisplay" : 1
            ])
    }

    static func getUserCurrentPassword(userId : String, onComplete: @escaping (Student)->Void){
        let ref = FIRDatabase.database().reference().child("users/\(userId)/")
        ref.observeSingleEvent(of: .value, with:
            { (snapshot) in
                let s = Student()
                
                s.userId = snapshot.key
                s.password = (snapshot.childSnapshot(forPath: "password").value as? String)!
                
                onComplete(s)
        })
    }
    
    static func retrieveUsersInfo(userId : String, onComplete: @escaping (Student)->Void){
        let ref = FIRDatabase.database().reference().child("users/\(userId)/")
        ref.observeSingleEvent(of: .value, with:
            { (snapshot) in
                let s = Student()
                
                s.userId = snapshot.key
                s.bio = snapshot.childSnapshot(forPath: "bio").value as? String
                s.displayPhotoUrl = snapshot.childSnapshot(forPath: "displayPhotoUrl").value as? String
                s.name = (snapshot.childSnapshot(forPath: "name").value as? String)!
                s.username = (snapshot.childSnapshot(forPath: "username").value as? String)!
                s.password = (snapshot.childSnapshot(forPath: "password").value as? String)!
                s.points = (snapshot.childSnapshot(forPath: "points").value as? Int)!
                s.school = (snapshot.childSnapshot(forPath: "school").value as? String)!
                
                onComplete(s)
        })
    }
    
    static func retrieveAllStudentInfoById(userId : String, onComplete: @escaping ([Student])->Void){
        var studList : [Student] = []
        var badgesList : [Badge] = []
        
        let ref = FIRDatabase.database().reference().child("users/\(userId)/")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            studList = []
            
            for record in snapshot.children{
                let r = record as! FIRDataSnapshot
                
                let s = Student()
                
                s.userId = r.key
                s.isAdmin = r.childSnapshot(forPath: "isAdmin").value as! Int
                if(s.isAdmin == 0){
                    s.bio = r.childSnapshot(forPath: "bio").value as? String
                    s.displayPhotoUrl = r.childSnapshot(forPath: "displayPhotoUrl").value as? String
                    s.name = (r.childSnapshot(forPath: "name").value as? String)!
                    s.username = (r.childSnapshot(forPath: "username").value as? String)!
                    s.password = (r.childSnapshot(forPath: "password").value as? String)!
                    s.points = (r.childSnapshot(forPath: "points").value as? Int)!
                    s.school = (r.childSnapshot(forPath: "school").value as? String)!
                    
                    //Child nodes
                    badgesList = []
                    let badge = r.childSnapshot(forPath: "badges").children
                    for badges in badge{
                        let l = badges as! FIRDataSnapshot
                        
                        let u = Badge()
                        u.badgeId = l.key
                        u.isDisplay = l.childSnapshot(forPath: "isDisplay").value as? Int
                        u.icon = l.childSnapshot(forPath: "icon").value as! String
                        
                        badgesList.append(u)
                    }
                    
                    s.badges = badgesList
                    studList.append(s)
                }
                
            }
            
            onComplete(studList)
        })
    }
    
    static func retrieveAllStudentInfo(onComplete: @escaping ([Student])->Void){
        var studList : [Student] = []
        var badgesList : [Badge] = []
        
        let ref = FIRDatabase.database().reference().child("users/")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            studList = []
            
            for record in snapshot.children{
                let r = record as! FIRDataSnapshot
                
                let s = Student()
                
                s.userId = r.key
                s.isAdmin = r.childSnapshot(forPath: "isAdmin").value as! Int
                if(s.isAdmin == 0){
                    s.bio = r.childSnapshot(forPath: "bio").value as? String
                    s.displayPhotoUrl = r.childSnapshot(forPath: "displayPhotoUrl").value as? String
                    s.name = (r.childSnapshot(forPath: "name").value as? String)!
                    s.username = (r.childSnapshot(forPath: "username").value as? String)!
                    s.password = (r.childSnapshot(forPath: "password").value as? String)!
                    s.points = (r.childSnapshot(forPath: "points").value as? Int)!
                    s.school = (r.childSnapshot(forPath: "school").value as? String)!
                    
                    //Child nodes
                    badgesList = []
                    let badge = r.childSnapshot(forPath: "badges").children
                    for badges in badge{
                        let l = badges as! FIRDataSnapshot
                        
                        let u = Badge()
                        u.badgeId = l.key
                        u.isDisplay = l.childSnapshot(forPath: "isDisplay").value as? Int
                        u.icon = l.childSnapshot(forPath: "icon").value as? String
                        
                        badgesList.append(u)
                    }
                    
                    s.badges = badgesList
                    studList.append(s)
                }
                
            }
            
            onComplete(studList)
        })
    }

    static func retrieveUsersDisplayBadge(userId : String, onComplete: @escaping ([Badge])->Void){
        var badgeList : [Badge] = []
        
        let ref = FIRDatabase.database().reference().child("users/\(userId)/badges/")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            badgeList = []
            
            for record in snapshot.children{
                let r = record as! FIRDataSnapshot
                
                let u = Badge()
                u.badgeId = r.key
                u.isDisplay = r.childSnapshot(forPath: "isDisplay").value as? Int
                u.icon = (r.childSnapshot(forPath: "icon").value as? String)!
                
                if(u.isDisplay == 1){
                    badgeList.append(u)
                }
            }
            onComplete(badgeList)
        })
    }
    
    static func retrieveAllUsersBadge(userId : String, onComplete: @escaping ([Badge])->Void){
        var badgeList : [Badge] = []
        
        let ref = FIRDatabase.database().reference().child("users/\(userId)/badges/")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            badgeList = []
            
            for record in snapshot.children{
                let r = record as! FIRDataSnapshot
                
                let u = Badge()
                u.badgeId = r.key
                u.isDisplay = r.childSnapshot(forPath: "isDisplay").value as? Int
                u.icon = (r.childSnapshot(forPath: "icon").value as? String)!
                
                badgeList.append(u)
            }
            onComplete(badgeList)
        })
    }
    
    static func retrieveAllSocialUserLikedPhotos(onComplete: @escaping ([Social])->Void){
        var socialList : [Social] = []
        var likedByList : [PhotoLike] = []
        
        let ref = FIRDatabase.database().reference().child("social/").queryOrdered(byChild: "postedDateTime")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            socialList = []
            likedByList = []
            
            //.reversed() - for descending order
            for record in snapshot.children.reversed(){
                let r = record as! FIRDataSnapshot
                
                let s = Social()
                
                s.socialId = r.key
                s.eventId = r.childSnapshot(forPath: "eventId").value as! String
                s.photoUrl = r.childSnapshot(forPath: "photoUrl").value as? String
                
                //Child nodes
                let likes = r.childSnapshot(forPath: "likedBy").children
                for liked in likes{
                    let l = liked as! FIRDataSnapshot
                    
                    let p = PhotoLike()
                    p.adminNo = l.key
                    p.isLike = (l.childSnapshot(forPath: "isLiked").value as? Int)!
                    
                    if((p.adminNo == (GlobalDM.CurrentUser?.userId)!) && (p.isLike == 1)){
                        likedByList.append(p)
                        s.likes = likedByList
                        socialList.append(s)
                    }
                }
                
            }
            
            onComplete(socialList)
        })
    }
    
    static func retrieveAllSocial(onComplete: @escaping ([Social])->Void){
        var socialList : [Social] = []
        var likedByList : [PhotoLike] = []
        var commentList : [PhotoComment] = []
        var flagReasonsList : [SocialFlag] = []
        
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
                //s.flagReason = r.childSnapshot(forPath: "flagReason").value as? String
                s.uploaderUsername = r.childSnapshot(forPath: "uploaderUsername").value as? String
                
                flagReasonsList = []
                let reasons = r.childSnapshot(forPath: "flagReasons").children
                for reason in reasons{
                    let sf = reason as! FIRDataSnapshot
                    
                    let f = SocialFlag()
                    f.userId = sf.key
                    f.flagReason = sf.value as! String
                    
                    flagReasonsList.append(f)
                }
                
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
                    
                    if((p.adminNo == (GlobalDM.CurrentUser?.userId)!)){
                            p.comments = commentList
                            likedByList.append(p)
                    }
                }
                
//                if(s.isFlagged == 0 || s.isFlagged == 2){
                    s.flagReasons = flagReasonsList
                    s.likes = likedByList
                    socialList.append(s)
//                }
            }
            
            onComplete(socialList)
        })
    }
    

    
    static func retrieveAllSocialUserPostedPhotos(onComplete: @escaping ([Social])->Void){
        var socialList : [Social] = []
        var likedByList : [PhotoLike] = []
        
        let ref = FIRDatabase.database().reference().child("social/").queryOrdered(byChild: "postedDateTime")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            socialList = []
            likedByList = []
            
            //.reversed() - for descending order
            for record in snapshot.children.reversed(){
                let r = record as! FIRDataSnapshot
                
                let s = Social()
                
                s.socialId = r.key
                s.eventId = r.childSnapshot(forPath: "eventId").value as! String
                s.photoUrl = r.childSnapshot(forPath: "photoUrl").value as? String
                s.uploader = r.childSnapshot(forPath: "uploader").value as? String
                
                if(s.uploader == (GlobalDM.CurrentUser?.userId)!){
                    socialList.append(s)
                    print("s.uploader - \(s.uploader)")
                }
            }
            
            onComplete(socialList)
        })
    }
    

}
