//
//  AdminEventDM.swift
//  NYP25
//
//  Created by iOS on 6/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit
import Firebase

class AdminEventDM: NSObject {
    //Create event
    
    //Retrieve all events
    static func retrieveAllEvents(onComplete: @escaping ([Event])->Void){
        var eventList : [Event] = []
        var feedbackList : [EventFeedback] = []
        var rsvpList : [EventRsvp] = []
        
        let ref = FIRDatabase.database().reference().child("events/")
        
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            for record in snapshot.children{
                let r = record as! FIRDataSnapshot
                
                let e = Event()
                
                e.eventId = r.key
                e.name = r.childSnapshot(forPath: "name").value as! String
                e.address = r.childSnapshot(forPath: "address").value as! String
                e.imageUrl = r.childSnapshot(forPath: "image").value as! String
                e.badgeId = r.childSnapshot(forPath: "badge").value as! String
                e.desc = r.childSnapshot(forPath: "description").value as! String
                e.startDate = r.childSnapshot(forPath: "startDate").value as! String
                e.endDate = r.childSnapshot(forPath: "endDate").value as! String
                e.startTime = r.childSnapshot(forPath: "startTime").value as! String
                e.endTime = r.childSnapshot(forPath: "endTime").value as! String
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
    
    //Delete event
}
