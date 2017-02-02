//
//  UserEventDM.swift
//  NYP25
//
//  Created by Kenneth on 30/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Firebase

class UserEventDM: NSObject {
    
    static func loadEvents(onComplete: @escaping ([Event])->Void){
        var eventList : [Event] = []
        let ref = FIRDatabase.database().reference().child("events/")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            eventList = []
            
            for record in snapshot.children{
                let r = record as! FIRDataSnapshot
                
                let e = Event()
                
                e.status = r.childSnapshot(forPath: "status").value as! String
                
                if e.status != "O" {
                    continue;
                }
                
                let date = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd"
                let dateString : Int = Int(formatter.string(from: date))!
                e.date = r.childSnapshot(forPath: "date").value as? String
                let dbDate : Int = Int(e.date!)!
                if dbDate < dateString {
                    continue;
                }
                
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
//                print("Event loaded.")
                eventList.append(e)
            }
            onComplete(eventList)
        })
        
    }

    
    
    static func checkIfRSVP(adm: String, eventId: String, onComplete: @escaping(String)->Void){
        var msg = "EXIST"
        print(adm + eventId)
        let ref = FIRDatabase.database().reference().child("eventAttendance/\(adm)/events/\(eventId)/rsvp")
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            if snapshot.exists(){
                msg = "EXIST"
                
            }else{
                msg = "NOT"
            }
            onComplete(msg)
        })
    }
    
    
    
    static func addRSVP(adm: String, eventId: String) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMDD, HH:mm:ss"
        let ref = FIRDatabase.database().reference().child("eventAttendance/\(adm)/events/\(eventId)")
        ref.updateChildValues(["rsvp" : formatter.string(from: now)])
    }
    
    static func removeRSVP(adm: String, eventId: String) {
        let ref = FIRDatabase.database().reference().child("eventAttendance/\(adm)/events/\(eventId)/rsvp")
        ref.removeValue()
    }
    

    
    
    //Update event
//    static func updateEvent(event : Event, eventImage : NSData?, eventBadge : NSData?){
//        let ref = FIRDatabase.database().reference().child("events/\(event.eventId)/")
//        
//        ref.updateChildValues([
//            "name" : event.name!,
//            "address" : event.address!,
//            "description" : event.desc!,
//            "date" : event.date!,
//            "startTime" : event.startTime!,
//            "endTime" : event.endTime!,
//            "status" : event.status
//            ])
//        
//        //Upload the image
//        if(eventImage != nil){
//            uploadEventImage(eventImage: eventImage!, eventId: event.eventId)
//        }
//        
//        //Upload the badge
//        if(eventBadge != nil){
//            uploadEventBadge(eventBadge: eventBadge!, eventId: event.eventId)
//        }
//    }
    
//    static func createEvent(event : Event, eventImage : NSData?, eventBadge : NSData?){
//        let key = FIRDatabase.database().reference().child("events").childByAutoId().key
//        let ref = FIRDatabase.database().reference().child("events/\(key)/")
//        
//        ref.setValue([
//            "name" : event.name,
//            "address" : event.address,
//            "description" : event.desc,
//            "date" : event.date,
//            "startTime" : event.startTime,
//            "endTime" : event.endTime,
//            "status" : event.status
//            ])
    
        //Upload the image
//        if(eventImage != nil){
//            uploadEventImage(eventImage: eventImage!, eventId: key)
//        }
//        
//        //Upload the badge
//        if(eventBadge != nil){
//            uploadEventBadge(eventBadge: eventBadge!, eventId: key)
//        }
//    }
}


