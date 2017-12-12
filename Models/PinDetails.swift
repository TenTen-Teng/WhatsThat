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
    let imageName: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, imageName: String) {
        self.title = title
        self.coordinate = coordinate
        self.imageName = imageName
        
        super.init()
    }
}
