//
//  LocationViewModel.swift
//  Location
//
//  Created by Sameh Mabrouk on 12/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import DesignSystem
import Utils
import RxSwift

protocol LocationViewModelDelgate: class {
    func didDismissLocation(with selectedLocation: Location?)
}

public class LocationViewModel {
    var didDismissLocation = PublishSubject<(Bool, Location?)>()
    var didDismiss = PublishSubject<Void>()
    public var disposeBag: DisposeBag = DisposeBag()
    
    private var foundLocations = [Location]()
    private var selectedLocation: Location?
    private var sections = [
        TableViewSection(items: [
            CellItem(itemType: .location, title: Localize.Location.Table.Cell.currentLocation, backgroundCorner: ItemBackgroundCorner.none)
        ])
    ]

    private let locationUsecase: LocationInteractable
    
    public init(locationUsecase: LocationInteractable) {
        self.locationUsecase = locationUsecase
    }
}

// MARK: - TableViewModelProtocol

extension LocationViewModel: TableViewModelProtocol {
    public var shouldShowSearchBar: Bool {
        return true
    }
    
    public var searchBarPlaceholderTitle: String? {
        return Localize.Location.Table.SearchBar.placeholder
    }
    
    public func shouldDeselectRow(at indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func didSelectItem(at indexPath: IndexPath) {
        if indexPath.row == 0 {
            locationUsecase.getUserLocation { [weak self] location in
                guard let self = self else { return }
                
                print("[User location]: \(location)")
                self.selectedLocation = location
                self.didDismissLocation.onNext((true, self.selectedLocation))
            }
        } else {
            var item = modelForItem(atIndex: indexPath.row, inSection: indexPath.section)
            item.isChecked = !item.isChecked
            sections[indexPath.section].items[indexPath.row] = item
            
            selectedLocation = foundLocations[indexPath.row - 1]
                        
            didDismissLocation.onNext((true, selectedLocation))
        }
    }
    
    public var title: String {
        return Localize.Location.title
    }
    
    public var shouldShowSectionHeaderTitle: Bool {
        return false
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
    
    public func searchFor(text: String) -> Observable<Void> {
        return locationUsecase.getLocationsFor(text: text).flatMap { [unowned self] (locations) -> Observable<Void> in
            var items = [TableViewCellItemPresentable]()
            items.append(CellItem(itemType: .location, title: Localize.Location.Table.Cell.currentLocation, backgroundCorner: ItemBackgroundCorner.none))
            
            locations.forEach { location in
                items.append(CellItem(itemType: .default, title: location.locality ?? "", backgroundCorner: ItemBackgroundCorner.none))
            }
            
            self.foundLocations = locations
            self.sections = [TableViewSection(items: items)]
            
            return Observable.just(())
        }
    }
}
