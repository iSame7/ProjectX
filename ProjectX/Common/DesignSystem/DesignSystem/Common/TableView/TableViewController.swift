//
//  TemperTableViewController.swift
//  Filters
//
//  Created by Sameh Mabrouk on 09/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import UIKit
import Utils

open class TableViewController<T: TableViewModelProtocol>: UIViewController, ViewType, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    public lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = DesignSystem.Colors.Palette.brandWhite.color
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
        tableView.registerCells(withTypes: [
            FilterTableViewCell.self,
            SliderTableViewCell.self,
            MultipleSelectorCell.self,
            LocationTableViewCell.self,
            DefaultTableViewCell.self,
            ActionTableViewCell.self,
            CustomTableViewCell.self,
            IconTextTableViewCell.self,
        ])
        tableView.register(DefaultTableHeaderView.self, forHeaderFooterViewReuseIdentifier: String(describing: DefaultTableHeaderView.self))
        tableView.register(DefaultTableFooterView.self, forHeaderFooterViewReuseIdentifier: String(describing: DefaultTableFooterView.self))
        
        return tableView
    }()
    
    lazy var searchBar: SearchBar = {
        let searchBar: SearchBar = SearchBarFactory().build()
        searchBar.placeholder = viewModel.searchBarPlaceholderTitle
        searchBar.delegate = self
        return searchBar
    }()
    
    open private (set) var bottomView = UIView()
    open private (set) var customCellView: CustomTableViewCellViewable?
    open private (set) var indexPathForRow: IndexPath!
    private var tableViewBottomInset: CGFloat = 20
    open var topAnchorConstant: CGFloat = 0
    
    public var viewModel: T!
    
    // MARK: - View lifecycle
    
    open override func viewDidLoad() {
        setupUI()
        
        setupObservers()
        
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: tableViewBottomInset, right: 0)
    }
    
    // MARK: - UITableViewDataSource
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numberOfSections()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfItems(in: section)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        indexPathForRow = indexPath
        
        var cell: TableViewCellConfigurable
        let item = viewModel.modelForItem(atIndex: indexPath.row, inSection: indexPath.section)
        
        switch item.itemType {
        case .filter:
            cell = tableView.getCell(forType: FilterTableViewCell.self)
        case .distance:
            cell = tableView.getCell(forType: SliderTableViewCell.self)
        case .selector:
            cell = tableView.getCell(forType: MultipleSelectorCell.self)
        case .location:
            cell = tableView.getCell(forType: LocationTableViewCell.self)
        case .custom:
            cell = tableView.getCell(forType: CustomTableViewCell.self)
            if let cell = cell as? CustomTableViewCell, let customCellView = customCellView {
                cell.configure(view: customCellView)
            }
        case .action:
            cell = tableView.getCell(forType: ActionTableViewCell.self)
        case .iconText:
            cell = tableView.getCell(forType: IconTextTableViewCell.self)
        case .default:
            cell = tableView.getCell(forType: DefaultTableViewCell.self)
        }
        
        cell.configure(with: item)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
            String(describing: DefaultTableHeaderView.self)) as? DefaultTableHeaderView else { return nil }
        
        if let subtitle = viewModel.subtitleForSection(section) {
            view.configure(with: viewModel.titleForSection(section), subtitleText: subtitle, font: viewModel.fontForTitleInSection(section))
            return view
        }

        view.configure(with: viewModel.titleForSection(section), labelStyle: viewModel.sectionStyle().style, textColor: viewModel.sectionStyle().color)
        
        return view
    }
    
    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: String(describing: DefaultTableFooterView.self)) as! DefaultTableFooterView
        view.configure(view: customViewForFooterIn(section: section))
        
        return view
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return viewModel.shouldShowSectionHeaderTitle ? viewModel.heightForHeaderIn(section: section) : 0
    }
    
    public func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return viewModel.shouldShowSectionFooter ? viewModel.heightForFooterIn(section: section) : 0
    }
    
    open func customViewForFooterIn(section: Int) -> CutomTableViewFooterViewable {
        preconditionFailure("customViewForHeaderIn(section:) is not implemented")
    }
    
    // MARK: UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if viewModel.shouldDeselectRow(at: indexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        viewModel.didSelectItem(at: indexPath)
        guard viewModel.shouldReloadTableOnSelection else { return }
        
        tableView.reloadData()
    }
    
    // MARK: - Setup UI
    
    open func setupUI() {
        view.backgroundColor = DesignSystem.Colors.Palette.brandWhite.color
        addSubViews()
        setupConstraints()
    }
    
    open func addSubViews() {
        if viewModel.shouldShowSearchBar {
            view.addSubview(searchBar)
        }
        
        view.addSubview(tableView)
        
        if viewModel.shouldShowBottomView {
            view.addSubview(bottomView)
        }
    }
    
    open func setupConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        if viewModel.shouldShowSearchBar {
            searchBar.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
                searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
                searchBar.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
                searchBar.heightAnchor.constraint(equalToConstant: 56),
                tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 23)
            ])
        } else {
            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: CGFloat(topAnchorConstant)),
            ])
        }
        
        if viewModel.shouldShowBottomView {
            NSLayoutConstraint.activate([
                bottomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                bottomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                tableView.bottomAnchor.constraint(equalTo: bottomView.topAnchor)
            ])
        } else {
            NSLayoutConstraint.activate([
                tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
        }
        
        NSLayoutConstraint.activate([
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    open func setupObservers() {
        viewModel.loadData().subscribe { [unowned self] _ in
            self.tableView.reloadData()
        }.disposed(by: viewModel.disposeBag)
    }
    
    public func reloadData() {
        tableView.reloadData()
    }
    
    public func refreshData() {
        viewModel.refreshData().subscribe { [unowned self] _ in
            self.reloadData()
        }.disposed(by: viewModel.disposeBag)
    }
}

// MARK: - SearchBarDelegate

extension TableViewController: SearchBarDelegate {
    public func searchBar(_ searchBar: SearchBar, textDidChange text: String) {
        viewModel.searchFor(text: text).subscribe { [unowned self] _ in
            self.tableView.reloadData()
        }.disposed(by: viewModel.disposeBag)
    }
    
    public func searchBarDidTapClearButton() {
        viewModel.searchFor(text: "").subscribe { [unowned self] _ in
            self.tableView.reloadData()
        }.disposed(by: viewModel.disposeBag)
    }
}
