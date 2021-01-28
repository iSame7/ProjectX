//
//  Location.swift
//  Core
//
//  Created by Sameh Mabrouk on 28/01/2021.
//

struct Location: Codable {
    let lat: Double
    let lng: Double
    let address: String?
    let crossStreet: String?
    let distance: Double?
    let postalCode: String?
    let cc: String?
    let city: String?
    let state: String?
    let country: String?
}
