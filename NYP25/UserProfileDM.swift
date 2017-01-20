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
    
    //Retrieve all images of event by ID
    static func retrieveEventPhotos(userId : String, onComplete: @escaping ([Social])->Void){
        var socialPhotos : [Social] = []
        
        let ref = FIRDatabase.database().reference().child("social/\(userId)/")
        
        ref.observeSingleEvent(of: .value, with:
            {(snapshot) in
                for record in snapshot.children{
                    let r = record as! FIRDataSnapshot
                    
                    let s = Social()
                    s.eventId = r.key
                    s.photoUrl = r.childSnapshot(forPath: "photoUrl").value as? String
                    
                    socialPhotos.append(s)
                    
                    onComplete(socialPhotos)
                }
        })
    }
    
//    //Retrieve current user info
//    static func retrieveAllUserInfo(userId : String, onComplete: @escaping (Student)->Void){
//        let ref = FIRDatabase.database().reference().child("users/\(userId)/")
//        
//        ref.observeSingleEvent(of: .value, with:
//            { (snapshot) in
//                let s = Student()
//                
//                s.userId = snapshot.key
//                s.username = (snapshot.childSnapshot(forPath: "username").value as? String)!
//                s.displayPhotoUrl = snapshot.childSnapshot(forPath: "displayPhotoUrl").value as? String
//                
//                onComplete(s)
//        })
//    }
    
    //Retrieve all events
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
}
