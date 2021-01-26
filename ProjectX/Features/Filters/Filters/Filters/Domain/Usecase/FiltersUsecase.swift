//
//  FiltersUsecase.swift
//  Filters
//
//  Created by Sameh Mabrouk on 18/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import RxSwift
import Core
import Location

public protocol FiltersLoadable {
    func getJobSections() -> Observable<[JobSectionDetail]>
    func getFilterPreferences() -> Observable<FilterPreferenceResource?>
}

public protocol FiltersInteractable: FiltersLoadable {
    func getAddressFromCoordinates(latitude: Double, Longitude: Double, completion: @escaping ((Location) -> Void))
}

class FiltersUsecase: FiltersInteractable {
    private let filterService: FilterServiceFetching
    private let filterPreferencesService: FilterPreferencesFetching
    private let locationService: LocationServiceChecking
    
    init(filterService: FilterServiceFetching, filterPreferencesService: FilterPreferencesFetching, locationService: LocationServiceChecking) {
        self.filterService = filterService
        self.filterPreferencesService = filterPreferencesService
        self.locationService = locationService
    }
    
    func getJobSections() -> Observable<[JobSectionDetail]> {
        return filterService.fetchJobSectionsCategories()
    }
    
    func getFilterPreferences() -> Observable<FilterPreferenceResource?> {
        return filterPreferencesService.fetchFiltersPreferences()
    }

    func getAddressFromCoordinates(latitude: Double, Longitude: Double, completion: @escaping ((Location) -> Void)) {
        return locationService.reversGeocode(longitude: Longitude, latitude: latitude, completion: completion)
    }
}
