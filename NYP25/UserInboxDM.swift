//
//  UserInboxDM.swift
//  NYP25
//
//  Created by Zhen Wei on 30/1/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

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
    
    //Retrive social images which are 'deleted'
    static func retrieveFlaggedSocialImage(onComplete: @escaping([Social]) -> Void){
        var flaggedImageList : [Social] = []
        let ref = FIRDatabase.database().reference().child("social/").queryOrdered(byChild: "isFlagged").queryStarting(atValue: 3).queryEnding(atValue: 3)
        ref.observe(FIRDataEventType.value, with:{
            (snapshot) in
            flaggedImageList = []
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
                //photo.flagReason = r.childSnapshot(forPath: "flagReason").value as? String
                photo.uploaderUsername = r.childSnapshot(forPath: "uploaderUsername").value as? String
                
                //Child nodes
                var flagReasonList : [SocialFlag] = []
                let flags = r.childSnapshot(forPath: "flagReasons").children
                for flag in flags{
                    let f = flag as! FIRDataSnapshot
                    
                    let sf = SocialFlag()
                    sf.userId = f.key
                    sf.flagReason = f.value as! String
                    
                    flagReasonList.append(sf)
                }
                
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
                photo.flagReasons = flagReasonList
                
                flaggedImageList.append(photo)
            }
            
            onComplete(flaggedImageList)
        })
        
    }
    
    //Deleting social image (After acknowledgement)
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
}
