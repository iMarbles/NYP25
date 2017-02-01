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
}


