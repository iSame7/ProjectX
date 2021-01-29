//
//  Location.swift
//  Core
//
//  Created by Sameh Mabrouk on 28/01/2021.
//

public struct Location: Codable {
    public let lat: Double
    public let lng: Double
    public let address: String?
    public let crossStreet: String?
    public let distance: Double?
    public let postalCode: String?
    public let cc: String?
    public let city: String?
    public let state: String?
    public let country: String?
    
    public init(lat: Double,
                lng: Double,
                address: String?,
                crossStreet: String?,
                distance: Double?,
                postalCode: String?,
                cc: String?,
                city: String?,
                state: String?,
                country: String?) {
        self.lat = lat
        self.lng = lng
        self.address = address
        self.crossStreet = crossStreet
        self.distance = distance
        self.postalCode = postalCode
        self.cc = cc
        self.city = city
        self.state = state
        self.country = country
    }
}
