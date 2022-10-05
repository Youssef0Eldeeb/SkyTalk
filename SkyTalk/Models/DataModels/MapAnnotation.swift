//
//  MapAnnotation.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 05/10/2022.
//

import Foundation
import MapKit

class MapAnnotation: NSObject, MKAnnotation{
    
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate
    }
}
