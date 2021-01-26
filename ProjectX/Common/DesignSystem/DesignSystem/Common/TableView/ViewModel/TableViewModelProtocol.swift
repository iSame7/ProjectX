//
//  TableViewModellable.swift
//  Filters
//
//  Created by Sameh Mabrouk on 08/02/2020.
//  Copyright © 2020 Temper B.V. All rights reserved.
//

import RxSwift

public protocol TableViewCellSelectable {
    func shouldDeselectRow(at indexPath: IndexPath) -> Bool
    func didSelectItem(at indexPath: IndexPath)
}

public protocol TableViewModelProtocol: TableViewCellSelectable {
    var title: String { get }
    var disposeBag: DisposeBag { get }
    var shouldShowSectionHeaderTitle: Bool { get }
    var shouldShowSectionFooter: Bool { get }
    var shouldShowSearchBar: Bool { get }
    var shouldShowBottomView: Bool { get }
    var searchBarPlaceholderTitle: String? { get }
    var shouldReloadTableOnSelection: Bool { get }
    func heightForHeaderIn(section: Int) -> CGFloat
    func heightForFooterIn(section: Int) -> CGFloat
    func numberOfSections() -> Int
    func numberOfItems(in section: Int) -> Int
    func modelForItem(atIndex index: Int, inSection section: Int) -> TableViewCellItemPresentable
    func titleForSection(_ section: Int) -> String
    func subtitleForSection(_ section: Int) -> String?
    func fontForTitleInSection(_ section: Int) -> UIFont
    func sectionStyle() -> (style: Label.Style, color: UIColor)
    func searchFor(text: String) -> Observable<Void>
    func loadData() -> Observable<Void>
    func refreshData() -> Observable<Void>
}

public extension TableViewModelProtocol {
    var shouldShowSearchBar: Bool {
        return false
    }
    
    var shouldShowBottomView: Bool {
        return false
    }
    
    var shouldShowSectionFooter: Bool {
        return false
    }

    var searchBarPlaceholderTitle: String? {
        return nil
    }
    
    var shouldReloadTableOnSelection: Bool {
        return true
    }
    
    var disposeBag: DisposeBag {
        return DisposeBag()
    }
    
    func heightForHeaderIn(section: Int) -> CGFloat {
        return 64.0
    }
    
    func heightForFooterIn(section: Int) -> CGFloat {
        return 64.0
    }
    
    func sectionStyle() -> (style: Label.Style, color: UIColor) { return (Label.Style.subtitleMedium, DesignSystem.Colors.Palette.brandBlack.color) }
    
    func didSelectItem(at indexPath: IndexPath) {}
    
    func searchFor(text: String) -> Observable<Void> { return Observable.just(()) }
    
    func loadData() -> Observable<Void> { return Observable.just(()) }
    
    func refreshData() -> Observable<Void> { return Observable.just(()) }
    
    func fontForTitleInSection(_ section: Int) -> UIFont {
        return Font(type: .subtitle(.medium)).instance
    }
    
    func subtitleForSection(_ section: Int) -> String? {
        return nil
    }
}

// MARK: - TableViewCellSelectable

extension TableViewCellSelectable {
    func shouldDeselectRow(at indexPath: IndexPath) -> Bool {
        return false
    }
    
    func didSelectItem(at indexPath: IndexPath) {}
}
