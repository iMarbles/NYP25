//
//  Location.swift
//  NYP25
//
//  Created by sjtan on 7/2/17.
//  Copyright © 2017 NYP. All rights reserved.
//

import Foundation
import MapKit

class Location: NSObject, MKAnnotation {
    
    var title: String?
    var subtitle: String?
    var colour: UIColor
    var coordinate: CLLocationCoordinate2D

    init(title: String, subtitle: String, colour: UIColor, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.colour = colour
        self.coordinate = coordinate
    }
}
