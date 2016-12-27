//
//  Event.swift
//  NYP25
//
//  Created by iOS on 6/12/16.
//  Copyright © 2016 NYP. All rights reserved.
//

import UIKit

class Event: NSObject {
    var eventId : String = ""
    var name : String?
    var address : String?
    var imageUrl : String?
    var badgeId : String?
    var desc : String?
    var date : String?
    var startTime : String?
    var endTime : String?
    var status : String = "C"
    var feedbackList : [EventFeedback]?
    var rsvpList : [EventRsvp]?
}
