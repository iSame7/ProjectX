//
//  DetailsResponse.swift
//  Core
//
//  Created by Sameh Mabrouk on 28/01/2021.
//

struct DetailsResult: Codable {
    let response: DetailsResponse
}

struct DetailsResponse: Codable {
    let venue: Venue
}
