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

    
    
    static func retrieveAllEventAttendance(adm: String, onComplete: @escaping([EventsInAttendance])->Void){
//        var attendanceList : [EventAttendance] = []
        var eventsInAttendanceList : [EventsInAttendance] = []
        
        let ref = FIRDatabase.database().reference().child("eventAttendance/")
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
//            attendanceList = []
            eventsInAttendanceList = []
            
            for record in snapshot.children{
                let r = record as! FIRDataSnapshot
                
                let a = EventAttendance()
                a.adminNo = r.key
                a.school = r.childSnapshot(forPath: "school").value as! String
                
                if (a.adminNo == adm) {
                //Child nodes of events
                let events = r.childSnapshot(forPath: "events").children
                for event in events{
                    let eFromDb = event as! FIRDataSnapshot
                    
                    let e = EventsInAttendance()
                    e.eventId = eFromDb.key
                    e.checkIn = eFromDb.childSnapshot(forPath: "checkIn").value as? String
                    e.rsvp = eFromDb.childSnapshot(forPath: "rsvp").value as? String
                    
                    
                    eventsInAttendanceList.append(e)
                }
                
//                a.events = eventsInAttendanceList
//                attendanceList.append(a)
            }
                
                onComplete(eventsInAttendanceList)
            }
        })
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


