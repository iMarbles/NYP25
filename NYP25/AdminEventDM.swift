//
//  AdminEventDM.swift
//  NYP25
//
//  Created by iOS on 6/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class AdminEventDM: NSObject {
    //Upload event image
    static func uploadEventImage(eventImage : NSData, eventId : String) {
        let storage = FIRStorage.storage().reference().child("/EventPhoto/\(eventId)")
      
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        
        storage.put(eventImage as Data, metadata: metadata){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString

                //store downloadURL at database
                FIRDatabase.database().reference().child("events/\(eventId)").updateChildValues(["image" : downloadURL])
            }
            
        }
    }
    
    //Create badge
    static func uploadEventBadge(eventBadge: NSData, eventId : String){
        let storage = FIRStorage.storage().reference().child("/Badges/\(eventId)")
        
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        storage.put(eventBadge as Data, metadata: metadata){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let downloadURL = metaData!.downloadURL()!.absoluteString
        
                //Create badge
                FIRDatabase.database().reference().child("badges/\(eventId)").setValue([
                    "icon": downloadURL,
                    "isAchievement": 0])
                
                //store badge for event
                FIRDatabase.database().reference().child("events/\(eventId)").updateChildValues(["badge" : eventId])
            }
            
        }
    }
    
    //Retrieve badge by ID (only for admin events)
    static func retrieveBadgeByEventId(id: String, onComplete: @escaping (Badge)->Void){
        let ref = FIRDatabase.database().reference().child("badges/\(id)/")
        
        ref.observeSingleEvent(of: .value, with:
            { (snapshot) in
                let badge = Badge()
                badge.badgeId = snapshot.key
                badge.icon = snapshot.childSnapshot(forPath: "icon").value as! String
                badge.isAchievement = snapshot.childSnapshot(forPath: "isAchievement").value as! Int
                
                onComplete(badge)
        })
    }
    
    
    //Create event
    static func createEvent(event : Event, eventImage : NSData?, eventBadge : NSData?){
        let key = FIRDatabase.database().reference().child("events").childByAutoId().key
        let ref = FIRDatabase.database().reference().child("events/\(key)/")
        
        ref.setValue([
            "name" : event.name,
            "address" : event.address,
            "description" : event.desc,
            "date" : event.date,
            "startTime" : event.startTime,
            "endTime" : event.endTime,
            "status" : event.status
            ])
        
        //Upload the image
        if(eventImage != nil){
            uploadEventImage(eventImage: eventImage!, eventId: key)
        }
        
        //Upload the badge
        if(eventBadge != nil){
            uploadEventBadge(eventBadge: eventBadge!, eventId: key)
        }
    }
    
    //Retrieve all events
    static func retrieveAllEvents(onComplete: @escaping ([Event])->Void){
        var eventList : [Event] = []
        var feedbackList : [EventFeedback] = []
        var rsvpList : [EventRsvp] = []
        
        let ref = FIRDatabase.database().reference().child("events/")

        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            eventList = []
            feedbackList = []
            rsvpList = []
            
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
                
                //Child node of feedbacks
                let feedbacks = r.childSnapshot(forPath: "feedbacks").children
                for feedback in feedbacks{
                    let feed = feedback as! FIRDataSnapshot
                    
                    let f = EventFeedback()
                    f.userId = feed.key
                    f.username = feed.childSnapshot(forPath: "username").value as! String
                    f.comment = feed.childSnapshot(forPath: "comment").value as! String
                    f.rating = feed.childSnapshot(forPath: "rating").value as! Int
                    
                    feedbackList.append(f)
                }
                
                //Child node of rsvp list
                let rsvps = r.childSnapshot(forPath: "rsvpList").children
                for rsvp in rsvps{
                    let reserve = rsvp as! FIRDataSnapshot
                    
                    let res = EventRsvp()
                    res.userId = reserve.key
                    res.username = reserve.childSnapshot(forPath: "username").value as! String
                    res.outcome = reserve.childSnapshot(forPath: "outcome").value as! String
                    
                    rsvpList.append(res)
                }
                
                e.feedbackList = feedbackList
                e.rsvpList = rsvpList
                
                eventList.append(e)
                
                onComplete(eventList)
            }
        })
    
    }
    
    //Update event
    static func updateEvent(event : Event, eventImage : NSData?, eventBadge : NSData?){
        let ref = FIRDatabase.database().reference().child("events/\(event.eventId)/")
        
        ref.updateChildValues([
            "name" : event.name!,
            "address" : event.address!,
            "description" : event.desc!,
            "date" : event.date!,
            "startTime" : event.startTime!,
            "endTime" : event.endTime!,
            "status" : event.status
            ])
        
        //Upload the image
        if(eventImage != nil){
            uploadEventImage(eventImage: eventImage!, eventId: event.eventId)
        }
        
        //Upload the badge
        if(eventBadge != nil){
            uploadEventBadge(eventBadge: eventBadge!, eventId: event.eventId)
        }
    }
    
    //Delete event
}
