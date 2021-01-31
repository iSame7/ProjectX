//
//  SearchResponse.swift
//  Core
//
//  Created by Sameh Mabrouk on 28/01/2021.
//

public struct SearchResponse: Codable {
    public let venues: [Venue]
    
    public init(venues: [Venue]) {
        self.venues = venues
    }
}
