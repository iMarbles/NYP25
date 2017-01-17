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
    
    //Retrieve all images of event by ID
    static func retrieveEventPhotos(onComplete: @escaping ([Social])->Void){
        var socialPhotos : [Social] = []
        
        let ref = FIRDatabase.database().reference().child("social/")
        
        ref.observeSingleEvent(of: .value, with:
            {(snapshot) in
                for record in snapshot.children{
                    let r = record as! FIRDataSnapshot
                    
                    let photo = Social()
                    photo.photoUrl = r.childSnapshot(forPath: "photoUrl").value as! String
                    //To add-on as needed
                    
                    socialPhotos.append(photo)
                    
                    onComplete(socialPhotos)
                }
        })
    }
    
    static func createPost(social : Social, socialPhotos : NSData?){
        let key = FIRDatabase.database().reference().child("social").childByAutoId().key
        let ref = FIRDatabase.database().reference().child("social/\(key)/")

//        ref.setValue(["caption" : social.caption])
        
        
//
//        ref.setValue([
//            "name" : social.name,
//            "address" : social.address,
//            "description" : social.desc,
//            "date" : social.date,
//            "startTime" : social.startTime,
//            "endTime" : social.endTime,
//            "status" : social.status
//            ])
//
        ref.setValue([
            "caption" : "\(social.caption!)"
            ])
        
        uploadEventImage(eventId: key, socialPhotos: socialPhotos!)
    }

    static func uploadEventImage(eventId : String, socialPhotos : NSData){
        
//        let eventId = FIRDatabase.database().reference().child("social").childByAutoId().key
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
}
