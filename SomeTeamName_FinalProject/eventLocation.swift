//
//  eventLocation.swift
//  SomeTeamName_FinalProject
//
//  Created by Williams-Capone, Larkin on 12/2/18.
//  Copyright © 2018 Wu, Justin. All rights reserved.
//

import Foundation
import MapKit

class eventLocation: NSObject, MKAnnotation {
    
    var title: String?
    var coordinate: CLLocationCoordinate2D;
    
    init( title: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
