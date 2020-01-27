//
//  LocationInformation.swift
//  Assignment2
//
//  Created by Ankit Shah on 2019-12-07.
//  Copyright © 2019 Ankit Shah. All rights reserved.
//

import Foundation
import CoreLocation

// class to set mandatory location informtion
class LocationInformation {
    var city:String?
    var latitude:CLLocationDegrees?
    var longitude:CLLocationDegrees?
    init(city:String? = "",latitude:CLLocationDegrees? = Double(0.0),longitude:CLLocationDegrees? = Double(0.0)) {
        self.city    = city
        self.latitude = latitude
        self.longitude = longitude
    }
}
