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
    
    static func uploadEventImage(socialPhotos : NSData) {
        let eventId = FIRDatabase.database().reference().child("events").childByAutoId().key
        let storage = FIRStorage.storage().reference().child("/SocialPhoto/\(eventId)")
        
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
