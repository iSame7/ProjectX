//
//  DetailsResponse.swift
//  Core
//
//  Created by Sameh Mabrouk on 28/01/2021.
//

public struct DetailsResult: Codable {
    public let response: DetailsResponse
}

public struct DetailsResponse: Codable {
    public let venue: Venue
}
