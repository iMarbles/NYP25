//
//  LeaderboardDM.swift
//  NYP25
//
//  Created by sjtan on 3/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class LeaderboardDM: NSObject {

    //color for pie chart
    static var sbmColor : UIColor = UIColor.yellow
    static var sclColor : UIColor = UIColor.red
    static var sdnColor : UIColor = UIColor(red:0.9059, green:0, blue:0.9882, alpha:1.0)
    static var segColor : UIColor = UIColor.green
    static var shsColor : UIColor = UIColor(red: 0.898, green: 0.6941, blue: 0.4471, alpha: 1.0)
    static var sitColor : UIColor = UIColor(red: 0.0824, green: 0.5804, blue: 0.9373, alpha: 1.0)
    static var sidmColor : UIColor = UIColor.purple
    
    
    static func retrieveAllEventAttendance(onComplete: @escaping([EventAttendance])->Void){
        var attendanceList : [EventAttendance] = []
        var eventsInAttendanceList : [EventsInAttendance] = []
        
        let ref = FIRDatabase.database().reference().child("eventAttendance/")
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            attendanceList = []
            eventsInAttendanceList = []
            
            for record in snapshot.children{
                let r = record as! FIRDataSnapshot
                
                let a = EventAttendance()
                a.adminNo = r.key
                a.school = r.childSnapshot(forPath: "school").value as! String
                
                //Child nodes of events
                eventsInAttendanceList = []
                let events = r.childSnapshot(forPath: "events").children
                for event in events{
                    let eFromDb = event as! FIRDataSnapshot
                    
                    let e = EventsInAttendance()
                    e.eventId = eFromDb.key
                    e.checkIn = eFromDb.childSnapshot(forPath: "checkIn").value as? String
                    e.rsvp = eFromDb.childSnapshot(forPath: "rsvp").value as? String
                    
                    eventsInAttendanceList.append(e)
                }
                
                a.events = eventsInAttendanceList
                attendanceList.append(a)
            }
            
            onComplete(attendanceList)
        })
    }

    static func retrieveAllEvents(onComplete: @escaping ([Event])->Void){
        var eventList : [Event] = []
        var feedbackList : [EventFeedback] = []
        //var rsvpList : [EventRsvp] = []
        
        let ref = FIRDatabase.database().reference().child("events/")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            eventList = []
            //feedbackList = []
            //rsvpList = []
            
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
                feedbackList = []
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
                
                /*
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
                 
                 e.rsvpList = rsvpList
                 */
                
                e.feedbackList = feedbackList
                eventList.append(e)
            }
            
            
            onComplete(eventList)
        })
        
    }

}
