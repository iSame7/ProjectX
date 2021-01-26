//
//  Filter.swift
//  Filters
//
//  Created by Sameh Mabrouk on 23/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

public class Filter: Equatable {
    public static func == (lhs: Filter, rhs: Filter) -> Bool {
        lhs.categories == rhs.categories &&
            lhs.distance == rhs.distance &&
            lhs.latitude == rhs.latitude &&
            lhs.longitude == rhs.longitude
    }
    
    public var categories: [String]?
    public var distance: String?
    public var longitude: String?
    public var latitude: String?
    
    public init() {}
}
