//
//  FilterService.swift
//  Filters
//
//  Created by Sameh Mabrouk on 18/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import RxSwift
import Core

public protocol FilterServiceFetching {
    func fetchJobSectionsCategories() -> Observable<[JobSectionDetail]>
}

public class FilterService: FilterServiceFetching {
    
    private var filterCache: FilterCaching

    public init(filterCache: FilterCaching) {
        self.filterCache = filterCache
    }
    
    public func fetchJobSectionsCategories() -> Observable<[JobSectionDetail]> {
     // fetchJobSectionsCategories implementation goes here.
        return .empty()
    }
}
