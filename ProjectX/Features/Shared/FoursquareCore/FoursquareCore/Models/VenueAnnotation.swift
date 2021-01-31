//
//  VenueAnnotation.swift
//  Core
//
//  Created by Sameh Mabrouk on 28/01/2021.
//

import Foundation
import MapKit

public class VenueAnnotation: NSObject, MKAnnotation {
    public let coordinate: CLLocationCoordinate2D
    public let title: String?
    public let subtitle: String?
    public let category: String?
    
    public init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String, category: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.category = category
    }
}
