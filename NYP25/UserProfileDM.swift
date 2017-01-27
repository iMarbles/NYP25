

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
    
    static func updatePassword(currentUser : String, password : String){
        let shaData = sha256(password)
        let shaHex =  shaData!.map { String(format: "%02hhx", $0) }.joined()

        let ref = FIRDatabase.database().reference().child("users/\(currentUser)/")

        ref.updateChildValues([
            "password" : shaHex
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
                u.isDisplay = r.childSnapshot(forPath: "isDisplay").value as! Int
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
                u.isDisplay = r.childSnapshot(forPath: "isDisplay").value as! Int
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
                s.photoUrl = r.childSnapshot(forPath: "photoUrl").value as? String
                
                //Child nodes
                let likes = r.childSnapshot(forPath: "likedBy").children
                for liked in likes{
                    let l = liked as! FIRDataSnapshot
                    
                    let p = PhotoLike()
                    p.adminNo = l.key
                    p.isLike = (l.childSnapshot(forPath: "isLiked").value as? Int)!
                    
                    if((p.adminNo == (GlobalDM.CurrentUser?.userId)!) && (p.isLike == 1)){
                        //                        print("p.adminNo - \(p.adminNo)")
                        //                        print("p.isLike - \(p.isLike)")
                        
                        likedByList.append(p)
                        s.likes = likedByList
                        socialList.append(s)
                    }
                }
                
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
