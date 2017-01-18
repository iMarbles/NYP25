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

    //Retrieve all events
    static func retrieveAllSocial(onComplete: @escaping ([Social])->Void){
        var socialList : [Social] = []
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        let result = formatter.string(from: date)
        
//        let ref = FIRDatabase.database().reference().child("social/")
//        let ref = FIRDatabase.database().reference().child("social/").queryOrdered(byChild: "postedDateTime")
        let ref = FIRDatabase.database().reference().child("social/").queryOrdered(byChild: "postedDateTime").queryEnding(atValue: result)
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            socialList = []
            
            for record in snapshot.children{
                let r = record as! FIRDataSnapshot
                
                let s = Social()
                
                s.eventId = r.key
                s.photoUrl = r.childSnapshot(forPath: "photoUrl").value as? String
                s.uploader = r.childSnapshot(forPath: "uploader").value as? String
                s.caption = r.childSnapshot(forPath: "caption").value as? String
                s.postedDateTime = r.childSnapshot(forPath: "postedDateTime").value as? String
                s.isFlagged = (r.childSnapshot(forPath: "isFlagged").value as? Int)!
                s.flagReason = r.childSnapshot(forPath: "flagReason").value as? String
                
                socialList.append(s)
            }
            
            onComplete(socialList)
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
                
                s.eventId = r.key
                s.uploader = r.childSnapshot(forPath: "uploader").value as? String
                s.photoUrl = r.childSnapshot(forPath: "photoUrl").value as? String

                socialList.append(s)
            }
            
            onComplete(socialList)
        })
    }
    
    
    
    //Retrieve all images of event by ID
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
    
    static func createPost(social : Social, socialPhotos : NSData?){
        let key = FIRDatabase.database().reference().child("social").childByAutoId().key
        let ref = FIRDatabase.database().reference().child("social/\(key)/")
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = DateFormatter.Style.medium
        let result = formatter.string(from: date)

        
        ref.setValue([
            "caption" : social.caption!,
            "uploader" : social.uploader!,
            "postedDateTime" : result,
            "isFlagged" : social.isFlagged,
            "flagReason" : social.flagReason!
            ])

//        ref.setValue([ "caption" : "\(social.caption!)" ])
        
        uploadEventImage(eventId: key, socialPhotos: socialPhotos!)
    }

    static func uploadEventImage(eventId : String, socialPhotos : NSData){
        let storage = FIRStorage.storage().reference().child("/SocialPhoto/\(eventId)/")
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storage.put(socialPhotos as Data, metadata: metadata){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
                
                //store downloadURL at database
                FIRDatabase.database().reference().child("social/\(eventId)").updateChildValues(["photoUrl" : downloadURL])
            }
            
        }
    }
    
    //Retrieve Profile Photo
    static func retrieveUserProfilePhoto(onComplete: @escaping ([Student])->Void){
        var userList : [Student] = []

        let ref = FIRDatabase.database().reference().child("users/")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
                    
            for record in snapshot.children{
                let r = record as! FIRDataSnapshot
                
                let stud = Student()
                
                stud.userId = r.key
                stud.name = (r.childSnapshot(forPath: "name").value as? String)!
                stud.displayPhotoUrl = r.childSnapshot(forPath: "displayPhoto").value as? String
                stud.username = (r.childSnapshot(forPath: "username").value as? String)!
                
                userList.append(stud)
            }
            
            onComplete(userList)
        })
    }
}
