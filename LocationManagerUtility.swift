//
//  LocationManagerUtility.swift
//  Assignment2
//
//  Created by Ankit Shah on 2019-12-07.
//  Copyright © 2019 Ankit Shah. All rights reserved.
//

import CoreLocation

// Location Manager Utility to share location data between multiple pages, we have used singleton pattern by taking reference from https://stackoverflow.com/a/54060404/2828085
// After taking reference from above mentioned site, we have made changes in code based on our requirements

class LocationManagerUtility: NSObject, CLLocationManagerDelegate {
  
  static let shared = LocationManagerUtility()
  
  let locationManager = CLLocationManager()
  var locationInfoCallBack: ((_ info:LocationInformation)->())!
  
  override init() {
    super.init()
    locationManager.delegate = self
  }
  
  func start(locationInfoCallBack:@escaping ((_ info:LocationInformation)->())) {  self.locationInfoCallBack = locationInfoCallBack
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    let l = locations[0]
    let info = LocationInformation()
    info.latitude = l.coordinate.latitude
    info.longitude = l.coordinate.longitude
    CLGeocoder().reverseGeocodeLocation(l) { placemark, error in
      guard error == nil,
        let placemark = placemark
        else
      {
        return
      }
      
      if placemark.count > 0 {
        let place = placemark[0]
        info.city = place.locality
      }
      
      self.locationInfoCallBack(info)
    }
    locationManager.stopUpdatingLocation()
  }
  
}
