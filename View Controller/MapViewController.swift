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
    var pinDetail = PinDetails(title: "", coordinate: CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0), imageName: "")
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
        //set pins to map
        for item in wikiResults {
            pinDetail = PinDetails(title: item.title, coordinate: CLLocationCoordinate2D(latitude: item.locations[0], longitude: item.locations[1]), imageName: item.imageName)
        
            mapView.addAnnotation(pinDetail)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //get image from document directorys
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
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
            //set map marker
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            //get image path
            let imagePAth = (self.getDirectoryPath() as NSString).appendingPathComponent(annotation.imageName + ".jpg")
            
            let fileManager = FileManager.default
            
            //if image exist, show it on map
            if fileManager.fileExists(atPath: imagePAth){
                view.image = UIImage(contentsOfFile: imagePAth)!
                
                //resize image to 30 * 30
                view.frame.size = CGSize(width: 30.0, height: 30.0)
            }else{
                print("No Image")
            }
        }
        return view
    }
    
    //when press info button, turn to detail page
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






