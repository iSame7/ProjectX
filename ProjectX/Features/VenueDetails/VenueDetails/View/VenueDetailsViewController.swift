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
import RxCocoa

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
    
    lazy var backButton: UIButton = {
        let button: UIButton = ButtonFactory().build()
        button.setBackgroundImage(IconFactory(icon: .back).build(), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    var backButtonTapped: ControlEvent<Void> {
        return backButton.rx.tap
    }
    
    private let viewData = ["New York", "London", "Cairo", "Amsterdam"]
    
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
    
    // MARK: - setupUI
    
    override func setupUI() {
        setupSubviews()
        setupConstraints()
        
        view.backgroundColor = .white
    }
    
    override func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16),
            backButton.widthAnchor.constraint(equalToConstant: 30),
            backButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupSubviews() {
        view.addSubview(tableView)
        stretchyHeader = VenueDetailsTableStretchyHeader(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width))
        let image = UIImage(named: "placeholder", in: Bundle(for: VenueDetailsViewController.self), with: nil)
        stretchyHeader.imageView.image = image
        tableView.tableHeaderView = stretchyHeader
        
        view.addSubview(backButton)
    }
    
    override func setupObservers() {
        viewModel.outputs.showVenueDetailsHeader.subscribe { [weak self] viewData in
            self?.stretchyHeader.setup(with: viewData)
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.outputs.showError.subscribe { [weak self] error in
            // show error
        }.disposed(by: viewModel.disposeBag)
        
        backButtonTapped
            .bind(to: viewModel.inputs.backButtonTapped)
            .disposed(by: viewModel.disposeBag)
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
