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
                    "icon": downloadURL])
                
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
    
    //Retrieve all images of event by ID
    static func retrieveEventPhotos(eventId : String, onComplete: @escaping ([Social])->Void){
        var socialPhotos : [Social] = []
        
        let ref = FIRDatabase.database().reference().child("social/").queryOrdered(byChild: "eventId").queryStarting(atValue: eventId).queryEnding(atValue: eventId)
        
        ref.observeSingleEvent(of: .value, with:
            {(snapshot) in
                for record in snapshot.children{
                    let r = record as! FIRDataSnapshot
                    
                    let photo = Social()
                    photo.socialId = r.key
                    photo.photoUrl = r.childSnapshot(forPath: "photoUrl").value as? String
                    //To add-on as needed
                    photo.uploader = r.childSnapshot(forPath: "uploader").value as? String
                    photo.caption = r.childSnapshot(forPath: "caption").value as? String
                    photo.postedDateTime = r.childSnapshot(forPath: "postedDateTime").value as? String
                    photo.isFlagged = (r.childSnapshot(forPath: "isFlagged").value as? Int)!
                    photo.flagReason = r.childSnapshot(forPath: "flagReason").value as? String
                    photo.uploaderUsername = r.childSnapshot(forPath: "uploaderUsername").value as? String
                    
                    //Child nodes
                    var likedByList : [PhotoLike] = []
                    let likes = r.childSnapshot(forPath: "likedBy").children
                    for liked in likes{
                        let l = liked as! FIRDataSnapshot
                        
                        let p = PhotoLike()
                        p.adminNo = l.key
                        p.isLike = (l.childSnapshot(forPath: "isLiked").value as? Int)!
                        
                        let comments = l.childSnapshot(forPath: "comments").children
                        var commentList : [PhotoComment] = []
                        for comment in comments{
                            let com = comment as! FIRDataSnapshot
                            
                            let c = PhotoComment()
                            c.commentId = com.key
                            c.comment = com.childSnapshot(forPath: "comment").value as? String
                            c.timestamp = com.childSnapshot(forPath: "timestamp").value as? String
                            c.username = com.childSnapshot(forPath: "username").value as? String
                            
                            commentList.append(c)
                        }
                        
                        p.comments = commentList
                        
                        likedByList.append(p)
                    }
                    
                    photo.likes = likedByList
                    
                    socialPhotos.append(photo)
                }
                onComplete(socialPhotos)
        })
    }
    
    static func retrieveUserPhotoById(userId: String, onComplete: @escaping(String?) -> Void){
        var userPhotoUrl : String?
        let ref = FIRDatabase.database().reference().child("users/\(userId)")
        ref.observeSingleEvent(of: .value, with:
        {(snapshot) in
            userPhotoUrl = snapshot.childSnapshot(forPath: "displayPhotoUrl").value as? String
            
            onComplete(userPhotoUrl)
        })
    }
    
    static func retrieveFlaggedSocialImage(onComplete: @escaping([Social]) -> Void){
        var flaggedImageList : [Social] = []
        let ref = FIRDatabase.database().reference().child("social/").queryOrdered(byChild: "isFlagged").queryStarting(atValue: 1).queryEnding(atValue: 1)
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            
            for record in snapshot.children{
                let r = record as! FIRDataSnapshot
                
                let photo = Social()
                photo.socialId = r.key
                photo.photoUrl = r.childSnapshot(forPath: "photoUrl").value as? String
                //To add-on as needed
                photo.uploader = r.childSnapshot(forPath: "uploader").value as? String
                photo.caption = r.childSnapshot(forPath: "caption").value as? String
                photo.postedDateTime = r.childSnapshot(forPath: "postedDateTime").value as? String
                photo.isFlagged = (r.childSnapshot(forPath: "isFlagged").value as? Int)!
                photo.flagReason = r.childSnapshot(forPath: "flagReason").value as? String
                photo.uploaderUsername = r.childSnapshot(forPath: "uploaderUsername").value as? String
                
                //Child nodes
                var likedByList : [PhotoLike] = []
                let likes = r.childSnapshot(forPath: "likedBy").children
                for liked in likes{
                    let l = liked as! FIRDataSnapshot
                    
                    let p = PhotoLike()
                    p.adminNo = l.key
                    p.isLike = (l.childSnapshot(forPath: "isLiked").value as? Int)!
                    
                    let comments = l.childSnapshot(forPath: "comments").children
                    var commentList : [PhotoComment] = []
                    for comment in comments{
                        let com = comment as! FIRDataSnapshot
                        
                        let c = PhotoComment()
                        c.commentId = com.key
                        c.comment = com.childSnapshot(forPath: "comment").value as! String
                        c.timestamp = com.childSnapshot(forPath: "timestamp").value as! String
                        c.username = com.childSnapshot(forPath: "username").value as! String
                        
                        commentList.append(c)
                    }
                    
                    p.comments = commentList
                    
                    likedByList.append(p)
                }
                
                photo.likes = likedByList
                
                flaggedImageList.append(photo)
            }
            
            onComplete(flaggedImageList)
        })
        
    }
    
    //Deleting social image
    static func deleteSocialImageBy(socialId : String){
        let storageRef = FIRStorage.storage().reference().child("/SocialPhoto/\(socialId)")
        storageRef.delete { error in
            if let error = error {
                // Uh-oh, an error occurred!
                print(error.localizedDescription)
            } else {
                // File deleted successfully
                //Delete the photo record
                let ref = FIRDatabase.database().reference().child("social/\(socialId)")
                ref.removeValue()
            }
        }
        
    }
    
    //Marking post as safe
    static func markSocialImageSafeWith(socialId: String){
        FIRDatabase.database().reference().child("social/\(socialId)").updateChildValues(["isFlagged": 0, "flagReason": ""])
        
    }
    
    //Admin Stats
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
    
    //Admin Attendance
    static func checkIfUserExist(adminNo: String, onComplete: @escaping(User) -> Void){
        let s = User()
        let ref = FIRDatabase.database().reference().child("users/\(adminNo)")
        ref.observeSingleEvent(of: .value, with: {
            (snapshot) in
            if snapshot.exists(){
                s.userId = snapshot.key
                s.school = snapshot.childSnapshot(forPath: "school").value as! String
            }
            
            onComplete(s)
        })
    }
    
    static func createAttendance(student: User, event: Event, onComplete: @escaping(String)->Void){
        var msg = "ERROR"
        let ref = FIRDatabase.database().reference().child("eventAttendance/\(student.userId)")
        ref.observeSingleEvent(of: .value, with: {
            (snapshot) in
            let now = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "YYYYMMDD, HH:mm:ss"
            
            if !snapshot.exists(){
                //Have to create a new item in firebase
                FIRDatabase.database().reference().child("eventAttendance/\(student.userId)/").setValue([
                    "school": student.school])
            }
            
            //Updating the attendance
            FIRDatabase.database().reference().child("eventAttendance/\(student.userId)/events/\(event.eventId)").updateChildValues([
                "checkIn": formatter.string(from: now)])
            
            AdminEventDM.awardEventBadge(student: student, event: event, onComplete: { (eventBadgeMsg) in
                msg = eventBadgeMsg
            })
            
            msg = "OK"
            
            onComplete(msg)
        })
    }
    
    static func awardEventBadge(student: User, event: Event, onComplete: @escaping(String)->Void){
        var msg = "OK"
        let ref = FIRDatabase.database().reference().child("users/\(student.userId)/badges/\(event.badgeId!)")
        ref.observeSingleEvent(of: .value, with: {
            (snapshot) in
          
            //Retrieve badge icon
            AdminEventDM.retrieveBadgeByEventId(id: event.eventId, onComplete: { (badge) in
                if !snapshot.exists(){
                    FIRDatabase.database().reference().child("users/\(student.userId)/badges/\(event.badgeId!)")
                        .setValue(["isDisplay" : 0])
                }
                
                FIRDatabase.database().reference().child("users/\(student.userId)/badges/\(event.badgeId!)")
                    .updateChildValues(["icon" : badge.icon])
                
                msg = "OK"
            })
            
            onComplete(msg)
        })
    }
}
