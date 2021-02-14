//
//  TipsTableViewController.swift
//  VenueDetails
//
//  Created by Sameh Mabrouk on 12/02/2021.
//

import UIKit
import DesignSystem
import FoursquareCore

typealias TipSelectionHandler = (() -> Void)

class TipsTableViewCell: UITableViewCell {
    
    struct ViewData {
        let tips: [TipItem]
    }
    
    // MARK: - Properties
    
    private var viewData: ViewData?
    
    var selectedTipClosure: TipSelectionHandler?

    static let reuseIdentifier = "TipsTableViewCell"
    
    private lazy var label: Label = {
        let label: Label = LabelFactory().textAlignment(.left).style(style: .footNoteMedium).textColor(with: DesignSystem.Colors.Palette.gray400.color).build()
        label.text = "Tips"
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero)
        tableView.estimatedRowHeight = 120
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(TipTableViewCell.self, forCellReuseIdentifier: TipTableViewCell.reuseIdentifier)        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    
    // MARK: - Initalizers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    // Resize cell according to table view size
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        if let viewData = viewData, !viewData.tips.isEmpty {
            tableView.layoutIfNeeded()
            return tableView.contentSize
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func setup(with viewData: ViewData, tipSelectionHandler: @escaping TipSelectionHandler) {
        self.viewData = viewData
        tableView.reloadData()
        selectedTipClosure = tipSelectionHandler
    }
}


// MARK: - Setup UI

private extension TipsTableViewCell {
    
    func setupUI() {
        selectionStyle = .none
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        contentView.addSubview(label)
        contentView.addSubview(tableView)
    }
    
    func setupConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        
        label.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 5),
            label.leftAnchor.constraint(equalTo: marginGuide.leftAnchor),
            label.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            tableView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 0),
            tableView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor)

        ])
    }
}

extension TipsTableViewCell: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewData?.tips.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TipTableViewCell.reuseIdentifier) as! TipTableViewCell
        
        if let tip = viewData?.tips[indexPath.row], let user = tip.user {
            cell.setup(with: TipTableViewCell.ViewData(userName: user.firstName ?? "--", userImageURL: (user.photo?.prefix != nil) ? "\(String(describing: user.photo?.prefix))500x500\(String(describing: user.photo?.suffix))" : nil , createdAt: Double(tip.createdAt ?? 0).getDateStringFromUTC(), tipText: tip.text ?? "--"))
        }
        return cell
    }

}

extension TipsTableViewCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTipClosure?()
    }
}
