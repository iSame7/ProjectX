//
//  ShiftOverviewUseCase.swift
//  Temper
//
//  Created by Sameh Mabrouk on 12/9/19.
//  Copyright © 2019 Temper B.V. All rights reserved.
//

import Foundation
import RxSwift
import Core
import Utils
import Filters

public protocol ShiftOverviewInteractable {
    // MARK: - Shifts
    func loadShifts(forDates dates: [Date], withFilters filters: Filter?) -> Observable<[ShiftOverviewDataContainer]>
    func subscribeToWorkOnDate(date: Date) -> Observable<Void>
    func unsubscribeToWorkOnDate(date: Date) -> Observable<Void>
    func loadUserPrefferedDates() -> Observable<[Date?]>
    
    // MARK: - Filters
    func getJobSections() -> Observable<[JobSectionDetail]>
    func getFilterPreferences() -> Observable<FilterPreferenceResource?>
    func getFilter() -> Observable<Filter>
}

public class ShiftOverviewUseCase: ShiftOverviewInteractable {
    
    private let shiftOverviewService: ShiftOverviewServiceFetching
    private let filterService: FilterServiceFetching
    private let filterPreferencesService: FilterPreferencesFetching
    
    init(shiftOverviewService: ShiftOverviewServiceFetching, filterService: FilterServiceFetching, filterPreferencesService: FilterPreferencesFetching) {
        self.shiftOverviewService = shiftOverviewService
        self.filterService = filterService
        self.filterPreferencesService = filterPreferencesService
    }
    
    public func loadShifts(forDates dates: [Date], withFilters filters: Filter?) -> Observable<[ShiftOverviewDataContainer]> {
        let datesWithShifts = dates.map { date -> Observable<(date: Date, shifts: [FreeflexShift])> in
            return shiftOverviewService.getShifts(forDate: date, with: filters)
        }
        
        return Observable.zip(datesWithShifts) { list -> [ShiftOverviewDataContainer] in
            return list.map({ datesWithShifts -> ShiftOverviewDataContainer in
                
                let (date, shifts) = datesWithShifts
                
                var items: [ShiftOverviewItem] = [HeaderItem(withDate: date.toString(dateFormat: .EEEE_d_MMMM))]
                let shiftOverviewItems: [ShiftOverviewItem] = shifts.map { RegularShiftItem(withShift: $0) }
                
                items.append(contentsOf: shiftOverviewItems)
                
                if items.count <= 1 {
                    items.append(NoResultsItem(withDate: date.toString(dateFormat: .EEEE_d_MMMM)))
                }

                if items.count > 2 { // (Header + 1 or more items)
                    items.append(EndOfResultsItem(withDate: date.toString(dateFormat: .EEEE_d_MMMM)))
                }
                
                return ShiftOverviewDataContainer(date: date, items: items)
            })
        }
    }
    
    public func subscribeToWorkOnDate(date: Date) -> Observable<Void> {
        return shiftOverviewService.subscribeToWorkOnDate(date: date)
    }
    
    public func unsubscribeToWorkOnDate(date: Date) -> Observable<Void> {
        return shiftOverviewService.unsubscribeToWorkOnDate(date: date)
    }
    
    public func loadUserPrefferedDates() -> Observable<[Date?]> {
        return shiftOverviewService.getUserPrefferedDates()
    }
}

extension ShiftOverviewUseCase {
    public func getJobSections() -> Observable<[JobSectionDetail]> {
        return filterService.fetchJobSectionsCategories()
    }
    
    public func getFilterPreferences() -> Observable<FilterPreferenceResource?> {
        return filterPreferencesService.fetchFiltersPreferences()
    }
    
    public func getFilter() -> Observable<Filter> {
        let filter = Filter()
        
        return Observable.zip(getJobSections(), getFilterPreferences()) { (_, filterPreferences) -> Filter in
            
            guard let preferences = filterPreferences, let userFilter = preferences.filter else {
                return filter
            }
            
            filter.categories = userFilter.categories
            filter.distance = userFilter.distance?.distance
            filter.longitude = userFilter.distance?.lon
            filter.latitude = userFilter.distance?.lat
            
            return filter
        }
    }
}
