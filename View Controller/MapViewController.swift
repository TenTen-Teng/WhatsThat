//
//  MapViewController.swift
//  Test2WhatsThat
//
//  Created by 李腾 on 12/11/17.
//  Copyright © 2017 李腾. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    var wikiResults = [WikipediaResult]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let pin = MKPointAnnotation()
        
        for item in wikiResults {
            pin.coordinate = CLLocationCoordinate2D(latitude: item.locations[0], longitude: item.locations[1])
            mapView.addAnnotation(pin)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
