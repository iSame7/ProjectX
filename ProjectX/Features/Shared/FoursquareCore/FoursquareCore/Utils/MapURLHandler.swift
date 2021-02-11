//
//  MapURLHandler.swift
//  VenueDetails
//
//  Created by Sameh Mabrouk on 11/02/2021.
//

import MapKit

public protocol MapURLHandling {
    func openMap(location: Location, type: MapType)
}

public enum MapType {
    case apple
    case google
}

public class MapURLHandler: MapURLHandling {
    
    public init() {}
    
    public func openMap(location: Location, type: MapType) {
        switch type {
        case .apple:
            let coordinate = CLLocationCoordinate2DMake(location.lat, location.lng)
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate, addressDictionary: nil))
            mapItem.name = location.address
            mapItem.openInMaps(launchOptions: nil)
        case .google:
            let googleMapsURL = "https://www.google.com/maps"
            guard let encodedTitle = location.address?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string:
                    "\(googleMapsURL)?q=\(encodedTitle)&center=\(String(location.lat)),\(String(location.lng))") else { return }
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
