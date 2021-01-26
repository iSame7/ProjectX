//
//  FilterViewModel.swift
//  Filters
//
//  Created by Sameh Mabrouk on 06/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import Foundation
import RxSwift
import Core
import DesignSystem
import Utils
import Location

public protocol FilterViewModelProtocol: ViewModelType {
    var title: String { get }
    
    var sections: [TableViewSection] { get }
    
    var disposeBag: DisposeBag { get }
    
    var didUpdateContent: PublishSubject<Void> { get }
    var didTapResetAll: PublishSubject<Void> { get }
    var didResetAll: PublishSubject<Void> { get }
    var didFinishCategoryCoordinator: PublishSubject<Void> { get }
    var didFinishLocation: PublishSubject<Location?> { get }
    var didTapJobSection: PublishSubject<(jobSectionName: String, categories: [JobCategoryDetail])> { get }
    var didTapLocation: PublishSubject<Void> { get }
    var didTapClose: PublishSubject<Void> { get }
    var didTapApplyButton: PublishSubject<Void> { get }
    var didChangeSliderValue: PublishSubject<Int> { get }
    
    var didDismiss: PublishSubject<Filter?> { get }
    var didApply: PublishSubject<Filter?> { get }
}

public class FilterViewModel: FilterViewModelProtocol, ViewModelType {
    
    private enum State {
        case loadPreference
        case refresh
        case reset
    }
    
    private var state = State.loadPreference
    private var filterCategoriesPreferences = [String]()
    private var filterPreferences: FilterPreferenceResource?
    private let filterUsecase: FiltersInteractable
    private var filterCache: FilterCaching
    private var jobSections = [JobSectionDetail]()
    private var city = "Amsterdam"
    private var distance = "20"
    private var selectedLocation: Location?
    
    public var sections = [TableViewSection]()
    public var disposeBag = DisposeBag()
    public var didUpdateContent = PublishSubject<Void>()
    public var didTapResetAll = PublishSubject<Void>()
    public var didResetAll = PublishSubject<Void>()
    
    public var didFinishCategoryCoordinator = PublishSubject<Void>()  {
        didSet {
            didFinishCategoryCoordinator.subscribe(onNext: { [weak self] in
                self?.didUpdateContent.onNext(())
            }).disposed(by: disposeBag)
        }
    }
    
    public var didFinishLocation = PublishSubject<Location?>() {
        didSet {
            didFinishLocation.subscribe(onNext: { [weak self] location in
                guard let cityName = location?.locality else {
                    return
                }
                
                print("[FilterMemCache] selected Lat / Lng \(location?.lat ?? 0.0) / \(location?.lng ?? 0.0)")
                
                self?.selectedLocation = location
                self?.city = cityName                
                self?.didUpdateContent.onNext(())
            }).disposed(by: disposeBag)
        }
    }
    
    public var didTapJobSection = PublishSubject<(jobSectionName: String, categories: [JobCategoryDetail])>()
    public var didTapLocation = PublishSubject<Void>()
    public var didTapClose = PublishSubject<Void>()
    public var didTapApplyButton = PublishSubject<Void>()
    public var didChangeSliderValue = PublishSubject<Int>()
    
    public var didDismiss = PublishSubject<Filter?>()
    public var didApply = PublishSubject<Filter?>()
    
    public init(filterUsecase: FiltersInteractable, filterCache: FilterCaching) {
        self.filterUsecase = filterUsecase
        self.filterCache = filterCache
        
        setupObservers()
    }
    
    private func setupObservers() {
        didTapResetAll.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            self.state = .reset
            
            self.createSections(jobSections: self.jobSections)
            
            self.didResetAll.onNext(())
        }).disposed(by: disposeBag)
        
        didTapClose.subscribe(onNext: { [weak self] in
            guard let self = self else { return }

            self.didDismiss.onNext(nil)
        }).disposed(by: disposeBag)
        
        didTapApplyButton.subscribe(onNext: { [weak self] in
            guard let self = self else { return }

            self.didApply.onNext(self.createFilterFromSelectedCategories())
        }).disposed(by: disposeBag)
        
        didChangeSliderValue.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            
            if let distance = Int(self.distance), value != distance {
                self.distance = "\(value)"
                
                self.didUpdateContent.onNext(())
            }
        }).disposed(by: disposeBag)
        
    }
}

extension FilterViewModel: TableViewModelProtocol {
    
    public var shouldShowBottomView: Bool {
        return true
    }
    
    public func heightForHeaderIn(section: Int) -> CGFloat {
        return section == 0 ? 64 : 55
    }
    
    public func shouldDeselectRow(at indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func didSelectItem(at indexPath: IndexPath) {
        if indexPath.section == 0 {
            guard let jobSectionName = jobSections[indexPath.row].name else {
                assertionFailure("Job section name is missing")
                
                return
            }
            
            didTapJobSection.onNext((jobSectionName: jobSectionName, categories: jobSections[indexPath.row].jobCategories))
        } else if indexPath.section == 1 && indexPath.row == 0 {
            didTapLocation.onNext(())
        }
    }
    
    public var title: String {
        return Localize.Filters.title
    }
    
    public var shouldShowSectionHeaderTitle: Bool {
        return true
    }
    
    public func numberOfSections() -> Int {
        return sections.count
    }
    
    public func numberOfItems(in section: Int) -> Int {
        sections[section].items.count
    }
    
    public func modelForItem(atIndex index: Int, inSection section: Int) -> TableViewCellItemPresentable {
        sections[section].items[index]
    }
    
    public func titleForSection(_ section: Int) -> String {
        sections[section].title ?? "" 
    }
    
    public func loadData() -> Observable<Void> {

        return Observable.zip(filterUsecase.getJobSections(), filterUsecase.getFilterPreferences()).flatMap { result -> Observable<Void> in
            let (jobSections, preferences) = result
            
            print("[FilterMemCache] Lat / Lng in filters \(preferences?.filter?.distance?.lat ?? "") / \(preferences?.filter?.distance?.lon ?? "")")
            
            self.filterPreferences = preferences
            
            if let categories = preferences?.filter?.categories {
                self.filterCategoriesPreferences = categories
            }
            
            if let distance = preferences?.filter?.distance?.distance {
                self.distance = distance
            }
            
            return Observable<Void>.create { [unowned self] observer in
                if let longitude = Double(preferences?.filter?.distance?.lon ?? ""),
                    let latitude = Double(preferences?.filter?.distance?.lat ?? "") {
                        
                    self.filterUsecase.getAddressFromCoordinates(latitude: latitude, Longitude: longitude) { [weak self] location in
                        guard let self = self, let city = location.locality else { return }
                        
                        self.city = city
                        self.selectedLocation = location
                        
                        observer.onNext(())
                    }
                }
                observer.onNext(())
                return Disposables.create()
            }.flatMap { _ -> Observable<Void> in
                self.state = .loadPreference
                self.createSections(jobSections: jobSections)
                    
                return Observable.just(())
            }
        }
    }
    
    public func refreshData() -> Observable<Void> {
        self.state = .refresh
        self.createSections(jobSections: jobSections)        
        
        return Observable.just(())
    }
}

private extension FilterViewModel {
    func createSections(jobSections: [JobSectionDetail]) {
        var items = [TableViewCellItemPresentable]()
        
        jobSections.enumerated().forEach { (index, jobSection) in
            var selectedCategoriesCount = 0
            jobSection.jobCategories.forEach { jobCategory in
                
                switch state {
                case .loadPreference:
                    if let jobCategoryId = jobCategory.id, filterCategoriesPreferences.contains(jobCategoryId) {
                        jobCategory.isSelected = true
                        selectedCategoriesCount += 1
                    } else {
                        jobCategory.isSelected = false
                    }
                case .refresh:
                    if jobCategory.isSelected {
                        selectedCategoriesCount += 1
                    }
                case .reset:
                    jobCategory.isSelected = false
                    break
                }
            }
            
            let backgroundCorner: ItemBackgroundCorner
            if index == 0 {
                backgroundCorner = .top(4)
            } else if index == jobSections.count - 1 {
                backgroundCorner = .bottom(4)
            } else {
                backgroundCorner = .none
            }
            
            let subtitle = "\(selectedCategoriesCount)/\(jobSection.jobCategories.count)"
            
            items.append(CellItem(itemType: .filter, title: jobSection.name ?? "", subtitle: subtitle, backgroundCorner: backgroundCorner))
            
        }
        
        self.jobSections = jobSections
        
        self.sections = [TableViewSection(items: items, title: Localize.Filters.Table.Section.categories)]
        
        self.sections.append(
            TableViewSection(items: [
                CellItem(itemType: .filter, title: city, subtitle: nil, backgroundCorner: .top(4)),
                CellItem(itemType: .distance, title: Localize.Filters.Table.Section.Location.Cell.distance, subtitle: "\(distance) KM", sliderValue: Float(distance) , didChangeSliderValue: didChangeSliderValue , backgroundCorner: .bottom(4)),
            ], title: Localize.Filters.Table.Section.location)
        )
    }
    
    func createFilterFromSelectedCategories() -> Filter {
        let filter = Filter()
        
        var categories = [String]()
        
        jobSections.forEach { jobSection in
            jobSection.jobCategories.forEach { jobCategory in
                if let jobCategoryId = jobCategory.id, jobCategory.isSelected {
                    categories.append(jobCategoryId)
                }
            }
        }
                
        filter.categories = categories
        filter.distance = distance
        
        filterPreferences?.filter?.categories = categories
        filterPreferences?.filter?.distance?.distance = distance
        
        if let selectedLocation = selectedLocation {
            let lat = "\(selectedLocation.lat)"
            let lng = "\(selectedLocation.lng)"
            
            filter.latitude = lat
            filter.longitude = lng
            
            filterPreferences?.filter?.distance?.lat = lat
            filterPreferences?.filter?.distance?.lon = lng
        }
    
        filterCache.preferences = filterPreferences

        return filter
    }
}
