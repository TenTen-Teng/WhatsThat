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
    var annotationTitle = ""
    var pinDetail = PinDetails(title: "", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0))
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        // Do any additional setup after loading the view.
        
        for item in wikiResults {
            pinDetail = PinDetails(title: item.title, coordinate: CLLocationCoordinate2D(latitude: item.locations[0], longitude: item.locations[1]))
        
            mapView.addAnnotation(pinDetail)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PinDetails else { return nil }
        
        let identifier = "mapDetailSegue"
        var view: MKMarkerAnnotationView

        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        performSegue(withIdentifier: "mapDetailSegue", sender: view.annotation?.title ?? "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "mapDetailSegue") {
            let photoDetailsViewControllFromMap = segue.destination as! PhotoDetailsViewController
        
            photoDetailsViewControllFromMap.titleName = sender as! String
        }
    }
}



