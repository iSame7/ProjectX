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
    
    public init(id: String, name: String, contact: Contact?, location: Location, categories: [Category], verified: Bool?, url: String?, stats: Stats?, likes: Likes?, rating: Double?, hours: Hours?, photos: VenuePhotos?, tips: Tips?) {
        self.id = id
        self.name = name
        self.contact = contact
        self.location = location
        self.categories = categories
        self.verified = verified
        self.url = url
        self.stats = stats
        self.likes = likes
        self.rating = rating
        self.hours = hours
        self.photos = photos
        self.tips = tips
    }
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
    
    public init(createdAt: Int?, text: String?, user: User?) {
        self.createdAt = createdAt
        self.text = text
        self.user = user
    }
}

public struct User: Codable {
    public let firstName: String?
    public let photo: UserPhoto?
}

public struct UserPhoto: Codable {
    public let prefix: String
    public let suffix: String
}
