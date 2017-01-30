//
//  UserInboxDM.swift
//  NYP25
//
//  Created by Zhen Wei on 30/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Firebase

class UserInboxDM: NSObject {
    //To retrieve all the events user has attended before
    static func retrieveAllAttendanceBy(userId: String, onComplete: @escaping([String]) -> Void){
        //To store the list of event IDs that the user has attended
        var eventsAttendedList : [String] = []
        
        let ref = FIRDatabase.database().reference().child("eventAttendance/\(userId)/events/")
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            if snapshot.exists(){
                for record in snapshot.children{
                   let r = record as! FIRDataSnapshot
                    
                    let checkIn = r.childSnapshot(forPath: "checkIn").value as? String
                    
                    //Only if user HAS ATTENDED
                    if checkIn != nil{
                        eventsAttendedList.append(r.key)
                    }
                }
            }
            
            onComplete(eventsAttendedList)
        })
    }
    
    //Load all events so async does not block
    static func retrieveAllEvents(onComplete: @escaping ([Event])->Void){
        var eventList : [Event] = []
        var feedbackList : [EventFeedback] = []
        
        let ref = FIRDatabase.database().reference().child("events/")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            eventList = []
            feedbackList = []
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

                e.feedbackList = feedbackList
                eventList.append(e)
            }
            
            
            onComplete(eventList)
        })
    }
    
    
    //Save feedback to event
    static func createFeedbackFor(eventId: String, feedback: EventFeedback, onComplete: @escaping(String) -> Void){
        var msg = "ERROR"
        
        FIRDatabase.database().reference().child("events/\(eventId)/feedbacks/\(feedback.userId)/").updateChildValues(
            ["comment": feedback.comment,
             "rating": feedback.rating,
             "username" : feedback.username])
        
        msg = "OK"
        
        onComplete(msg)
    }
}
