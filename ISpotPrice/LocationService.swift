//
//  LocationService.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 07/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import CoreLocation

open class LocationService {

    class func isLocationServiceEnabled() -> Bool {
        
        if CLLocationManager.locationServicesEnabled(){
            
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                return false
            case .authorizedAlways, .authorizedWhenInUse:
                return true
            default:
                print("Location service - Something wrong with Location services ")
                return false
            }
        } else {
            print("Location service - Serice is not enabled")
            return false
        }
    }
}
