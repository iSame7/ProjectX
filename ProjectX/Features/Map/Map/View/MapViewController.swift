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
    private let cellIdentifier = String(describing: CollectionViewCell.self)
    var venues = [Venue]()
    var venuePhotos : [String: String] = [:]
    var indexOfCellBeforeDragging = 0
    var scrollToItem = true
    var selectedItemIndex: Int = 0 {
        didSet {
            selectAnnotation(atIndext: selectedItemIndex)
        }
    }
    
    lazy var collectionViewLayout: UICollectionViewFlowLayout = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        return flowLayout
    }()
    
    lazy var mapView: Map = {
        MapFactory().build()
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        return collectionView
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
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // MARK: - SetupUI

    override func setupUI() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        view.addSubview(mapView)
        view.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        mapView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 93.0)
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
                self?.venues = venues

                for venue in venues {
                    print("get photo for venueId: \(venue.id)")
                    self?.viewModel.inputs.venuesPhotosRequested.onNext(venue.id)
                }
                self?.collectionView.reloadData()
            }
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.outputs.showVenuePhoto.subscribe {  [weak self] result in
            if let result = result.element {
                self?.venuePhotos[result.venueId] = result.photo
            }
        }.disposed(by: viewModel.disposeBag)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureCollectionViewLayoutItemSize()
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
        // This keeps the user location point as a default blue dot.
        if annotation is MKUserLocation { return nil }
        
        // Setup annotation view for map - we can fully customize the marker
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PlaceAnnotationView") as? MKMarkerAnnotationView
        
        // Setup annotation view
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
    
    // didSelect - setting currentSelected Venue
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if scrollToItem {
            if let venueAnnotation = view.annotation as? VenueAnnotation {
                let selectedVenueIndex = venues.firstIndex(where: { $0.name == venueAnnotation.title })
                let indexPath = IndexPath(row: selectedVenueIndex ?? 0, section: 0)
                collectionViewLayout.collectionView!.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    func selectAnnotation(atIndext index: Int) {
        scrollToItem = false
        if let annotation = (mapView.annotations.first { (annotation) -> Bool in
            let venueAnnotation = annotation as? VenueAnnotation
            return venueAnnotation?.title == venues[index].name
        }) {
            mapView.selectAnnotation(annotation)
            scrollToItem = true
            
            let venueAnnotation = annotation as? VenueAnnotation
            let selectedVenue = venues.first(where: { $0.name == venueAnnotation?.title })

            if let selectedVenue = selectedVenue {
                let selectedVenueLocation = CLLocation(latitude: CLLocationDegrees(selectedVenue.location.lat), longitude: CLLocationDegrees(selectedVenue.location.lng))
                // only move to another region if the selected venue's location in not in the current map region
                if !regionContains(region: mapView.region, location: selectedVenueLocation) {
                    let coordinates = CLLocationCoordinate2D(latitude: selectedVenue.location.lat, longitude: selectedVenue.location.lng)
                    let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
                    let viewRegion = MKCoordinateRegion(center: coordinates, span: span)
                    mapView.setRegion(viewRegion)
                }
            }
        }
    }
    
    // Standardises and angle to [-180 to 180] degrees
    func standardAngle( angle: inout CLLocationDegrees) -> CLLocationDegrees {
        angle = angle.truncatingRemainder(dividingBy: 360)
        return angle < -180 ? -360 - angle : angle > 180 ? 360 - 180 : angle
    }
    
    // confirms that a region contains a location
    func regionContains(region: MKCoordinateRegion, location: CLLocation) -> Bool {
        var latitudeAngleDiff = region.center.latitude - location.coordinate.latitude
        let deltaLat = abs(standardAngle(angle: &latitudeAngleDiff))
        var longitudeAngleDiff = region.center.longitude - location.coordinate.longitude
        let deltalong = abs(standardAngle(angle:&longitudeAngleDiff))
        return region.span.latitudeDelta >= deltaLat && region.span.longitudeDelta >= deltalong
    }
}
