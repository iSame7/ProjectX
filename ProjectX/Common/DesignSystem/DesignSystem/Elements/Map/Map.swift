//
//  Map.swift
//  DesignSystem
//
//  Created by Sameh Mabrouk on 27/01/2021.
//

import UIKit
import MapKit

@objc public protocol MapDelegate: MKMapViewDelegate {
    @objc func mapTapped()
}

public class Map: UIView {
    
    public weak var delegate: MapDelegate? {
        didSet {
            mapView.delegate = delegate
        }
    }
    
    public var annotations: [MKAnnotation] {
        mapView.annotations
    }
    
    public var region: MKCoordinateRegion {
        mapView.region
    }
    
    private let mapView: MapView = {
        return MapView(frame: .zero)
    }()
    
    private let footerLabel: Label = {
        return LabelFactory(style: .bodyRegular)
            .textColor(with: DesignSystem.Colors.Palette.gray700.color)
            .build()
    }()
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cornerRadius(_ radius: CGFloat) {
        mapView.layer.cornerRadius = radius
    }
    
    public func setRegion(latitude: Double, longitude: Double, latitudeDelta: Double, longitudeDelta: Double) {
        mapView.setRegion(centerLatitude: latitude, centerLongitude: longitude, latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
    }
    
    
    public func address(_ text: String) {
        footerLabel.text = text
    }
    
    public func addAnnotations(_ annotations: [MKAnnotation]) {
        mapView.addAnnotations(annotations)
    }
    
    public func selectAnnotation(_ annotation: MKAnnotation) {
        mapView.selectAnnotation(annotation, animated: true)
    }
    
    public func setRegion(_ region: MKCoordinateRegion) {
        mapView.setRegion(region, animated: true)
    }
}

// MARK: - Setup UI

private extension Map {
    func setupUI() {
        setupSubviews()
        setupConstraints()
        setupInteraction()
    }
    
    func setupSubviews() {
        addSubview(mapView)
        addSubview(footerLabel)
    }
    
    func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: topAnchor),
            mapView.leftAnchor.constraint(equalTo: leftAnchor),
            mapView.rightAnchor.constraint(equalTo: rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    func setupInteraction() {
        isUserInteractionEnabled = true
        mapView.isUserInteractionEnabled = true
        addTapGestureRecognizer()
    }
    
    func addTapGestureRecognizer() {
        let tapGR = UITapGestureRecognizer(target: self, action: #selector(tap))
        addGestureRecognizer(tapGR)
    }
    
    @objc func tap() {
        delegate?.mapTapped()
    }
}
