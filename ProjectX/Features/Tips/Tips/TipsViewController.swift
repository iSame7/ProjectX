//
//  TipsViewController.swift
//  Tips
//
//  Created Sameh Mabrouk on 14/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Utils
import DesignSystem
import Core
import FoursquareCore
import RxCocoa

class TipsViewController: ViewController<TipsViewModel> {
    
    // MARK: - Properties
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TipTableViewCell.self, forCellReuseIdentifier: TipTableViewCell.reuseIdentifier)
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var backButton: UIButton = {
        let button: UIButton = ButtonFactory().build()
        button.setBackgroundImage(IconFactory(icon: .back).build(), for: .normal)
        button.backgroundColor = .clear
        return button
    }()
    
    private var stretchyHeader: TableStretchyHeader!
    
    private var viewData: ViewData?
    
    var backButtonTapped: ControlEvent<Void> {
        return backButton.rx.tap
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupObservers()
        
        viewModel.inputs.viewState.onNext(.loaded)
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
        stretchyHeader = TableStretchyHeader(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width), viewData: viewModel.buildTableHeaderViewData())
        tableView.tableHeaderView = stretchyHeader
        
        view.addSubview(backButton)
    }
    
    override func setupObservers() {
        viewModel.outputs.showVenueDetailsHeader.subscribe { [weak self] event in
            if let viewData = event.element {
                self?.stretchyHeader.setup(with: viewData)
            }
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.outputs.showTips.subscribe { [weak self] event in
            self?.viewData = event.element
            self?.tableView.reloadData()
        }.disposed(by: viewModel.disposeBag)
        
        backButtonTapped
            .bind(to: viewModel.inputs.backButtonTapped)
            .disposed(by: viewModel.disposeBag)
    }
}

// MARK: - UITableViewDataSource

extension TipsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData?.tips.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TipTableViewCell.reuseIdentifier) as! TipTableViewCell
        
        if let tip = viewData?.tips[indexPath.row], let user = tip.user {
            cell.setup(with: viewModel.buildTipTableCellViewData(userName: user.firstName ?? "--", userImageURL: (user.photo?.prefix != nil) ? "\(String(describing: user.photo?.prefix))500x500\(String(describing: user.photo?.suffix))" : nil , createdAt: Double(tip.createdAt ?? 0).getDateStringFromUTC(), tipText: tip.text ?? "--"))
        }
        return cell
    }
}

// MARK: - UITableViewDataSource

extension TipsViewController: UITableViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? TableStretchyHeader else { return }
        
        header.scrollViewDidScroll(scrollView: tableView)
    }
}

extension TipsViewController {
    
    struct ViewData {
        let tips: [TipItem]
    }
}
