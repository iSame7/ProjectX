//
//  ShiftOverviewViewController.swift
//  Temper
//
//  Created by Sameh Mabrouk on 12/16/19.
//  Copyright © 2019 Temper B.V. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Core
import DesignSystem
import SkeletonView
import Utils

public class ShiftOverviewViewController: UIViewController, ViewType, Alertable {
    public var viewModel: ShiftOverviewViewModel!
    
    private var isLoading = false
    private var isTraveling = false
    private var sectionToTravelTo = 0
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()

        tableView.register(ShiftOverviewHeaderCell.self, forCellReuseIdentifier: "HeaderCell")
        tableView.register(ShiftOverviewCell.self, forCellReuseIdentifier: "OverviewCell")
        tableView.register(NoResultsCell.self, forCellReuseIdentifier: "NoResultsCell")
        tableView.register(EndOfResultsCell.self, forCellReuseIdentifier: "EndOfResultsCell")
        tableView.register(BannerCell.self, forCellReuseIdentifier: "BannerCell")
        
        tableView.showsVerticalScrollIndicator = false
        tableView.scrollsToTop = false
        
        return tableView
    }()
    
    let dateScrollerHeight: Float = 56
    
    public typealias GenericViewModel = ShiftOverviewViewModel
    
    lazy var filterButton: UIBarButtonItem = {
        let button: UIButton = ButtonFactory()
            .backgroundColor(with: .clear)
            .titleColor(with: DesignSystem.Colors.Palette.secondary500.color, for: .normal)
            .font(of: Font(type: .body(.medium)))
            .textAlignment(alignment: .center)
            .titleEdgeInsets(edgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
            .title(title: Localize.ShiftOverview.Button.filters)
            .build()
        
        let imageView = UIImageView(image: IconFactory<UIImage>(icon: .filter)
            .build()
            .withAlignmentRectInsets(UIEdgeInsets(top: -4, left: -4, bottom: -4, right: -4)))
        
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = DesignSystem.Colors.Palette.secondary500.color
        
        button.rx.tap.bind(onNext: { [weak self] in
            self?.viewModel.inputs.onTapFiltersButton.onNext(())
        }).disposed(by: viewModel.disposeBag)
        
        button.addSubview(imageView)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        guard let titleLabel = button.titleLabel else {
            return UIBarButtonItem()
        }
        
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 28),
            
            imageView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 4),
            imageView.rightAnchor.constraint(equalTo: button.rightAnchor),
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: 28),
            imageView.widthAnchor.constraint(equalToConstant: 28)
        ])
        
        let barButtonItem = UIBarButtonItem(customView: button)
        barButtonItem.tintColor = DesignSystem.Colors.Palette.secondary500.color
        
        return barButtonItem
    }()
    
    lazy var dateScroller: DateScroller = {
        let dateScroller: DateScroller = DateScrollerFactory(fromDate: Date(), numberOfDays: viewModel.daysForDateScroller).build()
        dateScroller.delegate = self
        
        return dateScroller
    }()
    
    lazy var feedbackGenerator: UISelectionFeedbackGenerator = {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        
        return generator
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupObservers()
        setupConstraints()
        
        viewModel.startup().subscribe { [unowned self] event in
            guard let filter = event.element else {
                return
            }
            
            self.viewModel.filter = filter
            self.tableView.delegate = self
            self.tableView.dataSource = self
            
            self.tableView.reloadData()
        }.disposed(by: viewModel.disposeBag)
    }
}

extension ShiftOverviewViewController {
    
    public func setupUI() {
        navigationController?.navigationItem.largeTitleDisplayMode = .automatic
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: Font(type: .title1).instance, NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font(type: .subtitle(.medium)).instance, NSAttributedString.Key.foregroundColor: UIColor.black]
        
        view.backgroundColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        
        view.addSubview(tableView)
        
        navigationItem.rightBarButtonItem = filterButton
        tableView.separatorStyle = .none
        
        navigationController?.navigationBar.addSubview(dateScroller)
        dateScroller.backgroundColor = DesignSystem.Colors.Palette.brandWhite.color
        navigationController?.navigationBar.topItem?.title = Localize.ShiftOverview.title
    }
    
    public func setupObservers(){
        viewModel.insertUpdate.subscribe { [unowned self] event in
            guard let indexPath = event.element else {
                return
            }
            
            UIView.performWithoutAnimation {
                self.tableView.beginUpdates()
                
                self.tableView.reloadSections(IndexSet(integer: indexPath.section), with: .none)
                
                self.tableView.endUpdates()
            }
            
            self.isLoading = false
            
        }.disposed(by: viewModel.disposeBag)
        
        viewModel.resetTableView.observeOn(MainScheduler.instance).subscribe(onNext: { [unowned self] _ in
            let indexPathToScrollTo = IndexPath(row: 0, section: 0)
            
            self.dateScroller.selectDate(Date())
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: indexPathToScrollTo, at: .top, animated: false)
            
        }).disposed(by: viewModel.disposeBag)
        
        viewModel.openUrlInBrowser.subscribe(onNext: { [weak self] url in
            
//            self?.showSafariViewControllerWith(url: url)
        }).disposed(by: viewModel.disposeBag)
        
        viewModel.showInAppNotification.subscribe(onNext: { [weak self] (title, subtitle, emoji) in
//            self?.showInAppNotification(title: title, subtitle: subtitle, emoji: emoji)
        }).disposed(by: viewModel.disposeBag)
        
        viewModel.outputs.showAlert.subscribe(onNext: { [weak self] (title, subtitle, actionTitle) in
//            self?.showAlert(title: title, message: subtitle, cancelActionTitle: actionTitle, showInWindow: true)
        }).disposed(by: viewModel.disposeBag)
    }
    
    public func setupConstraints() {
        dateScroller.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: CGFloat(dateScrollerHeight)),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        
        guard let navigationController = navigationController else {
            return
        }
        
        NSLayoutConstraint.activate([
            dateScroller.heightAnchor.constraint(equalToConstant: CGFloat(dateScrollerHeight)),
            dateScroller.leftAnchor.constraint(equalTo: navigationController.navigationBar.leftAnchor),
            dateScroller.rightAnchor.constraint(equalTo: navigationController.navigationBar.rightAnchor),
            dateScroller.topAnchor.constraint(equalTo: navigationController.navigationBar.bottomAnchor, constant: 8),
        ])
    }
}

extension ShiftOverviewViewController: DateScrollerDelegate {
    
    public func didSelectDate(_ date: Date) {
        guard let dateInViewIndexPath = tableView.indexPathsForVisibleRows?.first else {
            return
        }
        
        let shiftOverviewItemContainer = viewModel.shiftOverviewItems[dateInViewIndexPath.section]
        let dateInView = shiftOverviewItemContainer.date
        
        let calendar = Calendar.current
        
        let date1 = calendar.startOfDay(for: dateInView)
        let date2 = calendar.startOfDay(for: date)
        
        let delta = calendar.dateComponents([.day], from: date1, to: date2).day ?? 0
        
        let indexPathToScrollTo = IndexPath(row: 0, section: dateInViewIndexPath.section + delta)
        self.isLoading = true
        
        isTraveling = true
        sectionToTravelTo = indexPathToScrollTo.section
        
        dateScroller.selectDate(date)
        
        tableView.scrollToRow(at: indexPathToScrollTo, at: .top, animated: true)
        
    }
}

extension ShiftOverviewViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.shiftOverviewItems[section].items.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shiftOverviewItemContainer = viewModel.shiftOverviewItems[indexPath.section]
        let shiftOverviewItem = shiftOverviewItemContainer.items[indexPath.row]
        
        if let data = shiftOverviewItem as? BannerItem {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "BannerCell", for: indexPath) as? BannerCell {
                
                cell.data = data
                cell.bannerView.callToActionTapped.asObservable().bind(to: viewModel.bannerCallToActionTapped).disposed(by: viewModel.disposeBag)
                cell.bannerView.closeButtonTapped.asObservable().bind(to: viewModel.hideBannerView).disposed(by: viewModel.disposeBag)
                
                return cell
            }
        }
        
        if let data = shiftOverviewItem as? HeaderItem {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as? ShiftOverviewHeaderCell {
                
                cell.data = data
                
                return cell
            }
        }
        
        if let data = shiftOverviewItem as? RegularShiftItem {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath) as? ShiftOverviewCell else {
                return UITableViewCell()
            }
            
            cell.data = data
            
            return cell
        }
        
        if shiftOverviewItem is LoadingItem {
            
            if !isTraveling && !isLoading {
                isLoading = true
                self.viewModel.loadDataFor(container: shiftOverviewItemContainer, indexPath: indexPath)
            }
            
            if isTraveling && sectionToTravelTo == indexPath.section {
                isLoading = true
                self.viewModel.loadDataFor(container: shiftOverviewItemContainer, indexPath: indexPath)
                
                isTraveling = false
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "OverviewCell", for: indexPath) as? ShiftOverviewCell else {
                return UITableViewCell()
            }
            
            cell.showLoading()
            
            return cell
        }
        
        if let data = shiftOverviewItem as? EndOfResultsItem {
            let isSubscribed = viewModel.containsSubscriptionForDate(date: shiftOverviewItemContainer.date)
            
            data.isSubscribed = isSubscribed
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "EndOfResultsCell", for: indexPath) as? EndOfResultsCell else {
                return UITableViewCell()
            }
            
            cell.data = data
            
            return cell
        }
        
        if let data = shiftOverviewItem as? NoResultsItem {
            let isSubscribed = viewModel.containsSubscriptionForDate(date: shiftOverviewItemContainer.date)
            
            data.isSubscribed = isSubscribed
            
            let nextContainerIndex = indexPath.section + 1
            
            if viewModel.shiftOverviewItems.count > nextContainerIndex {
                let nextContainer = viewModel.shiftOverviewItems[indexPath.section + 1]
                isLoading = true
                self.viewModel.loadDataFor(container: nextContainer, indexPath: IndexPath(row: 0, section: nextContainerIndex))
            }
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NoResultsCell", for: indexPath) as? NoResultsCell else {
                return UITableViewCell()
            }
            
            cell.data = data
            
            return cell
            
        }
        
        return UITableViewCell()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let shiftOverviewItemContainer = viewModel.shiftOverviewItems[indexPath.section]
        let shiftOverviewItem = shiftOverviewItemContainer.items[indexPath.row]
        
        if shiftOverviewItem is BannerItem {
            return 176
        }
        
        if shiftOverviewItem is HeaderItem {
            if indexPath.section == 0 {
                return 24.0 + 16.0
            } else {
                return 24.0 + 32.0
            }
        }
        
        if shiftOverviewItem is NoResultsItem {
            return 164 + 16.0
        }
        
        if shiftOverviewItem is EndOfResultsItem {
            return 124 + 16.0
        }
        
        return 264.0 + 16.0
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.shiftOverviewItems.count
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView != tableView {
            return
        }
        
        guard let firstVisibleIndex = tableView.indexPathsForVisibleRows?.first else {
            return
        }
        
        let shiftOverviewItemContainer = viewModel.shiftOverviewItems[firstVisibleIndex.section]
        
        dateScroller.selectDate(shiftOverviewItemContainer.date)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shiftOverviewItemContainer = viewModel.shiftOverviewItems[indexPath.section]
        let shiftOverviewItem = shiftOverviewItemContainer.items[indexPath.row]
        
        if shiftOverviewItem is EmptyStateable {
            // Subscribe or unsubscribe from this date
            viewModel.toggleSubscriptionFor(date: shiftOverviewItemContainer.date)
            
            UIView.performWithoutAnimation {
                tableView.reloadRows(at: [indexPath], with: .none)
            }
            
            feedbackGenerator.selectionChanged()
            
            return
        }
        
        viewModel.inputs.onTapItem.onNext(viewModel.shiftOverviewItems[indexPath.section].items[indexPath.row])
    }
}
