//
//  VenueDetailsViewController.swift
//  VenueDetails
//
//  Created Sameh Mabrouk on 04/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Utils
import DesignSystem

class VenueDetailsViewController: ViewController<VenueDetailsViewModel> {
    
    // MARK: - Properties
    
    private lazy var tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var stretchyHeader: VenueDetailsTableStretchyHeader!
    
    private let viewData = ["New York", "London", "Cairo", "Amsterdam"]
    
    // MARK: - Lifecycle

	override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - setupUI

    override func setupUI() {
        setupSubviews()
        setupConstraints()
        
        view.backgroundColor = .white
        navigationController?.setNavigationBarHidden(false, animated: true)        
    }
    
    override func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupSubviews() {
        view.addSubview(tableView)
        stretchyHeader = VenueDetailsTableStretchyHeader(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        let image = UIImage(named: "placeholder", in: Bundle(for: VenueDetailsViewController.self), with: nil)
        stretchyHeader.imageView.image = image
        stretchyHeader.setup(with: VenueDetailsTableStretchyHeader.ViewData(title: "Title", description: "Description"))
        tableView.tableHeaderView = stretchyHeader
    }
    
    override func setupObservers() {
        
    }
}

// MARK: - UITableViewDataSource

extension VenueDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewData[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDataSource

extension VenueDetailsViewController: UITableViewDelegate {
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? VenueDetailsTableStretchyHeader else { return }
        
        header.scrollViewDidScroll(scrollView: tableView)
    }
}
