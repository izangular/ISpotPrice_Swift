//
//  PropertyInfo.swift
//  ISpotPrice
//
//  Created by IIT Web Dev on 08/08/17.
//  Copyright © 2017 IIT Web Dev. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond

class PropertyInfo{
    var authToken: String = ""
    var authStatus: Int = -1
    
    //Binding
    var imageBase64 = Observable<String>("")
    let latitude = Observable<Double>(0)
    let longitude = Observable<Double>(0)
    
    let appraisalValue = Observable<Float>(0)
    let rating = Observable<Float>(0)
    let street = Observable<String>("")
    let zip = Observable<String>("")
    let town = Observable<String>("")
    let country = Observable<String>("")
    let category = Observable<String>("")
    let catCode = Observable<Int>(0)
    
    var surfaceLiving = Observable<Float>(0)
    var landSurface = Observable<Float>(0)
    var roomNb = Observable<Float>(0)
    var bathNb = Observable<Float>(0)
    var buildYear = Observable<Int>(0)
    
    
    init() {
        
//        _ = surfaceLiving.observeNext(with: { (value) in print(self.surfaceLiving.value) })
//        _ = roomNb.observeNext(with: { (value) in print(self.roomNb.value) })
        
        surfaceLiving.next(50)
        landSurface.next(200)
        roomNb.next(1)
        bathNb.next(1)
        buildYear.next(1950)
        
        street.next("")
        zip.next("")
        town.next("")
        appraisalValue.next(0)
        rating.next(0)
        country.next("")
        category.next("")
        catCode.next(0)
        
        imageBase64.next("base")
        latitude.next(47.408934)
        longitude.next(8.547593)
        
        authToken = ""
        authStatus = -1
    }
    
}
