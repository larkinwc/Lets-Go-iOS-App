//
//  MapViewController.swift
//  SomeTeamName_FinalProject
//
//  Created by Nancy Tran on 11/30/18.
//  Copyright © 2018 Wu, Justin. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    let locationManager = CLLocationManager()
    
    var eventSession = eventAPI()
    @IBOutlet weak var mapView: MKMapView!
    
    
    override func viewDidLoad() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestLocation()
        }
        mapView.delegate = self;
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow //Moves view to user position
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadEvents(_:)), name: .arrayValueChanged, object:nil)
    }
    func getCoords() -> ([Any], [String]){

        var coords: [Any] = []
        var names: [String] = []
            for i in events {
                let lat = (i.value(forKey: "lat") as! NSString).doubleValue
                let long = (i.value(forKey: "long") as! NSString).doubleValue
                let name = i.value(forKey: "name") as! NSString
                names.append(name as String)
                coords.append([lat, long])
            }
        return (coords, names)
        }

    @objc func loadEvents(_ notification: Notification) {
        print(events)
        if(!events.isEmpty) {
            let eventCoords: [Any];
            let eventNames: [String];
            // get coords and names
            let res = getCoords()
            // unpack tuple
            eventCoords = res.0
            eventNames = res.1
            for i in 0...eventCoords.count - 1 {
                let temp = eventCoords[i] as! [Double]
                let annotation = eventLocation(title: eventNames[i], coordinate: CLLocationCoordinate2D(latitude: temp[0], longitude: temp[1]))
                mapView.addAnnotation(annotation)
            }
        }
    }
   
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            print(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    
    
    
    
}


