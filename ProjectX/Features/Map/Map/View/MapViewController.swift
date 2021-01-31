//
//  MapViewController.swift
//  Map
//
//  Created Sameh Mabrouk on 27/01/2021.
//  Copyright © 2021 Sameh Mabrouk. All rights reserved.
//

import UIKit
import Core
import DesignSystem
import MapKit
import FoursquareCore

class MapViewController: ViewController<MapViewModel> {

    // MARK: - Properties
    
    private var annotationsForVenues = [MKAnnotation]()

    lazy var mapView: Map = {
        MapFactory().build()
    }()
        
    // MARK: - Lifecycle

	override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.inputs.viewState.onNext(.loaded)
        setupUI()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - SetupUI

    override func setupUI() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        view.addSubview(mapView)
    }
    
    override func setupConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    override func setupObservers() {
        viewModel.outputs.showUserLocation.subscribe { [weak self] (lat, lng) in
            self?.mapView.setRegion(latitude: lat, longitude: lng, latitudeDelta: 0.1, longitudeDelta: 0.1)
            
            self?.viewModel.inputs.restaurantsListAroundCoordinatedRequested.onNext(("\(lat)", "\(lng)"))
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.outputs.showRestaurantsList.subscribe {  [weak self] result in
            if let venues = result.element {
                self?.addAnnotationsToMap(venues: venues)
//                for venue in venues {
//                    print("get photo for venueId: \(venue.id)")
////                    presenter.getPhotos(venueId: venue.id)
//                }
//                collectionView.reloadData()
            }
        }.disposed(by: viewModel.disposeBag)
    }
}

private extension MapViewController {
    
    func addAnnotationsToMap(venues: [Venue]){
        mapView.delegate = self
        venues.forEach { (venue) in
            let venueAnnotation = VenueAnnotation(coordinate: CLLocationCoordinate2D(latitude: venue.location.lat, longitude: venue.location.lng), title: venue.name, subtitle: venue.contact?.formattedPhone ?? "", category: venue.categories.first?.id ?? "")
            annotationsForVenues.append(venueAnnotation)
        }
        DispatchQueue.main.async {
            self.mapView.addAnnotations(self.annotationsForVenues)
        }
    }
}


extension MapViewController: MapDelegate {
    
    func mapTapped() {}
    
    // View for each annotation
    internal func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        //this keeps the user location point as a default blue dot.
        if annotation is MKUserLocation { return nil }
        
        //setup annotation view for map - we can fully customize the marker
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PlaceAnnotationView") as? MKMarkerAnnotationView
        
        //setup annotation view
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "PlaceAnnotationView")
            if let venueAnnotation = annotation as? VenueAnnotation, let imageType = ImageType(rawValue: venueAnnotation.category ?? "")  {
                annotationView?.glyphImage = UIImage.glyphFor(imageType: imageType)
            } else {
                annotationView?.glyphImage = IconFactory(icon: .restaurant).build()
            }
            annotationView?.canShowCallout = false
            annotationView?.animatesWhenAdded = true
            annotationView?.markerTintColor = UIColor.orange
            annotationView?.isHighlighted = true
        } else {
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    //callout tapped/selected
    internal func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
}
