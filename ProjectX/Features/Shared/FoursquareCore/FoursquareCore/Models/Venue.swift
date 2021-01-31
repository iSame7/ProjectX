//
//  Venue.swift
//  Core
//
//  Created by Sameh Mabrouk on 28/01/2021.
//

public struct Venue: Codable {
    public let id: String
    public let name: String
    public let contact: Contact?
    public let location: Location
    public let categories: [Category]
    public let verified: Bool?
    public let url: String?
    public let stats: Stats?
    public let likes: Likes?
    public let rating: Double?
    public let hours: Hours?
    public let photos: VenuePhotos?
    public let tips: Tips?
}

public struct Hours: Codable {
    public let status: String?
}

public struct RichStatus: Codable {
    public let text: String?
}

public struct VenuePhotos: Codable {
    public let count: Int?
    public let groups: [Group]?
}

public struct Group: Codable {
    public let type: String?
    public let name: String?
    public let count: Int?
    public let items: [Photo]?
}

public struct Tips: Codable {
    public let count: Int
    public let groups: [TipsGroup]
}

public struct TipsGroup: Codable {
    public let type: String?
    public let name: String?
    public let count: Int?
    public let items: [TipItem]?
}

public struct TipItem: Codable {
    public let createdAt: Int?
    public let text: String?
    public let user: User?
}

public struct User: Codable {
    public let firstName: String?
    public let photo: UserPhoto?
}

public struct UserPhoto: Codable {
    public let prefix: String
    public let suffix: String
}
