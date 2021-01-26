//
//  LocationService.swift
//  Location
//
//  Created by Sameh Mabrouk on 13/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import Utils
import MapKit
import RxSwift
import MapboxGeocoder

public typealias UserLocationCompletionHandler = (Location) -> Void

public protocol LocationServiceChecking: LocationServiceSearching {
    func requestUserLocation( completion: @escaping UserLocationCompletionHandler)
    func reversGeocode(longitude: CLLocationDegrees, latitude: CLLocationDegrees, completion: @escaping UserLocationCompletionHandler)
}

public protocol LocationServiceSearching {
    func searchLocationsFor(text: String) -> Observable<[Location]>
}

public class LocationService: NSObject {
    private let locationManager: CLLocationManager
    private var locationUpdateCompletion: UserLocationCompletionHandler!
    private let geocoder: Geocoder
    
    public required init(locationManager: CLLocationManager, geocoder: Geocoder) {
        self.locationManager = locationManager
        self.geocoder = geocoder
        
        super.init()
    }
}

// MARK: - LocationServiceChecking

extension LocationService: LocationServiceChecking {
    
    public func requestUserLocation( completion: @escaping UserLocationCompletionHandler) {
        requestLocationPermissionIfNeeded()
        
        locationUpdateCompletion = completion
        locationManager.delegate = self
        
        locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    public func reversGeocode(longitude: CLLocationDegrees, latitude: CLLocationDegrees, completion: @escaping UserLocationCompletionHandler) {
        locationUpdateCompletion = completion
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        reversGeocode(location: location)
        
    }
}

// MARK: - Helpers

private extension LocationService {
    func requestLocationPermissionIfNeeded() {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            let alertController = UIAlertController(title: nil, message: "Turn On Location Services to Allow \"Temper\" to Determine Your Location", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
                //opens phone Settings so user can authorize permission
                guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
                
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            
            UIApplication.shared.keyWindow?.rootViewController?.presentedViewController?.present(alertController, animated: true, completion: nil)
        default:
            print("location permission is already granted")
        }
    }
}

//MARK: - CLLocationManagerDelegate

extension LocationService: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        reversGeocode(location: location)
        locationManager.delegate = nil
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

// MARK: - Geocoding

private extension LocationService {
    func reversGeocode(location: CLLocation) {

        let options = ReverseGeocodeOptions(coordinate: location.coordinate)
        options.allowedScopes = [.place]

        geocoder.geocode(options) { [unowned self] (placemarks, _, _) in

            guard let placemark = placemarks?.first else {
                return
            }
            
            guard let placemarkLocation = placemark.location else {
                return
            }
            
            let location = Location(lat: placemarkLocation.coordinate.latitude, lng: placemarkLocation.coordinate.longitude, locality: placemark.name)
            
            self.locationUpdateCompletion(location)
        }
    }
}

// MARK: - LocationServiceSearching

extension LocationService: LocationServiceSearching {
    public func searchLocationsFor(text: String) -> Observable<[Location]> {
        let options = ForwardGeocodeOptions(query: text)

        options.allowedISOCountryCodes = ["NL"]
        
        options.allowedScopes = [.place]
        
        return Observable.create { [unowned self] observer in
            self.geocoder.geocode(options) { (placemarks, _, _)  in
                guard let placemarks = placemarks else {
                    return
                }
                
                let locations = placemarks.map({ placemark -> Location in
                        guard let location = placemark.location else {
                            return Location(lat: 0, lng: 0, locality: "")
                        }
                        
                    return Location(lat: location.coordinate.latitude, lng: location.coordinate.longitude, locality: placemark.name)
                })
                
                observer.onNext(locations)
            }
            
            return Disposables.create()
        }
    }
}
