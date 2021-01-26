//
//  CategoryFilterViewModel.swift
//  Filters
//
//  Created by Sameh Mabrouk on 10/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import DesignSystem
import Core
import RxSwift

protocol FilterViewModellable: TableViewModelProtocol {
    var didTapSelectAll: PublishSubject<Void> { get }
    var didSelectAll: PublishSubject<Void> { get }
    var didTapDeselectAll: PublishSubject<Void> { get }
    var didDeselectAll: PublishSubject<Void> { get }
    var didDismissFilterCategory: PublishSubject<Void> { get }
    var result: PublishSubject<Void> { get }
    
    var disposeBag: DisposeBag { get }
}

public class FilterCategoryViewModel {
    private var items: [Selectable]
    private let jobSectionName: String
    private var sections = [TableViewSection]()
    private var showFooter: Bool = false
    
    var didTapSelectAll = PublishSubject<Void>()
    var didSelectAll = PublishSubject<Void>()
    var didTapDeselectAll = PublishSubject<Void>()
    var didDeselectAll = PublishSubject<Void>()
    var didDismissFilterCategory = PublishSubject<Void>()
    var result = PublishSubject<Void>()
    public var disposeBag: DisposeBag = DisposeBag()
    
    public init(sectionItems: [Selectable], sectionName: String, showFooter: Bool) {
        self.items = sectionItems.sorted(by: { (lhs, rhs) -> Bool in
            guard let lhsName = lhs.name, let rhsName = rhs.name else {
                return false
            }

            return lhsName < rhsName
        })
        
        self.jobSectionName = sectionName
        self.showFooter = showFooter
        
        setupObservables()
    }
}

extension FilterCategoryViewModel: FilterViewModellable {
    
    public var shouldShowBottomView: Bool {
        return showFooter
    }
    
    public func shouldDeselectRow(at indexPath: IndexPath) -> Bool {
        return false
    }
    
    public func didSelectItem(at indexPath: IndexPath) {
        var item = modelForItem(atIndex: indexPath.row, inSection: indexPath.section)
        items[indexPath.row].isSelected = !item.isChecked
        item.isChecked = !item.isChecked
        sections[indexPath.section].items[indexPath.row] = item
    }
    
    public var title: String {
        return jobSectionName
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
    
    public func loadData() -> Observable<Void> {
        convertCategoriesToSections()
        
        return Observable.just(())
    }
}

private extension FilterCategoryViewModel {
    func setupObservables() {
        didTapSelectAll.subscribe(onNext: { [weak self] in
            self?.updateSelectionState(selectAll: true)
            self?.convertCategoriesToSections()
            self?.didSelectAll.onNext(())
        }).disposed(by: disposeBag)
        
        didTapDeselectAll.subscribe(onNext: { [weak self] in
            self?.updateSelectionState(selectAll: false)
            self?.convertCategoriesToSections()
            self?.didDeselectAll.onNext(())
        }).disposed(by: disposeBag)
        
        didDismissFilterCategory.subscribe(onNext: { [weak self] in
            self?.result.onNext(())
        }).disposed(by: disposeBag)
    }
    
    func convertCategoriesToSections() {
        var sectionItems = [TableViewCellItemPresentable]()
        items.forEach { category in
            guard let categoryName = category.name else {
                assertionFailure("Category name is missing")
                return
            }
            
            sectionItems.append(CellItem(itemType: .selector, title: categoryName, backgroundCorner: ItemBackgroundCorner.none, isChecked: category.isSelected))
        }
        
        sections = [TableViewSection(items: sectionItems)]
    }
    
    func updateSelectionState(selectAll: Bool) {
        items = items.map({ category in
            var newCategory = category
            newCategory.isSelected = selectAll
            
            return newCategory
        })
    }
}
