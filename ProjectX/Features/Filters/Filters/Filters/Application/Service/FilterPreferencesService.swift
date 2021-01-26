//
//  FilterPreferencesService.swift
//  Filters
//
//  Created by Sameh Mabrouk on 20/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import RxSwift
import Core

public protocol FilterPreferencesFetching {
    func fetchFiltersPreferences() -> Observable<FilterPreferenceResource?>
}

public class FilterPreferencesService: FilterPreferencesFetching {
    
    private var filterCache: FilterCaching
    
    public init(filterCache: FilterCaching) {
        self.filterCache = filterCache
    }
    
    public func fetchFiltersPreferences() -> Observable<FilterPreferenceResource?> {
       // fetchFiltersPreferences implementation goes here.
        return .empty()
    }
}
