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

class MapViewController: ViewController<MapViewModel> {

    // MARK: - Properties
    
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
        }.disposed(by: viewModel.disposeBag)
    }
}
