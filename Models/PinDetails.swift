//
//  PinDetails.swift
//  Test2WhatsThat
//
//  Created by 李腾 on 12/11/17.
//  Copyright © 2017 李腾. All rights reserved.
//

import Foundation
import MapKit
import Contacts

class PinDetails: NSObject, MKAnnotation {
    let title: String?
    let coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
        
        super.init()
    }
}
