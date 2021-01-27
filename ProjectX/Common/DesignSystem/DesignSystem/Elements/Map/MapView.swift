//
//  MapView.swift
//  DesignSystem
//
//  Created by Sameh Mabrouk on 27/01/2021.
//

import MapKit

class MapView: MKMapView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addPin(latitude: Double, longitude: Double, title: String?) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = title
        addAnnotation(annotation)
    }
    
    func setRegion(centerLatitude: Double, centerLongitude: Double, distance: Double) {
        let center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: distance, longitudinalMeters: distance)
        setRegion(region, animated: true)
    }
}
