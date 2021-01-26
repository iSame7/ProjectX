//
//  FilterPreferenceResource.swift
//  Filters
//
//  Created by Sameh Mabrouk on 26/01/2021.
//

public struct FilterPreferenceResource {
    public var filter: FilterCategoryPreferenceResource?
}

public struct FilterCategoryPreferenceResource {
    public var categories: [String]?
    public var distance: FilterDistanceResource?
}

public struct FilterDistanceResource {
    public var distance: String?
    public var lon: String?
    public var lat: String?
}
