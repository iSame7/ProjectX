//
//  Photo.swift
//  Core
//
//  Created by Sameh Mabrouk on 28/01/2021.
//

import Foundation

public struct VenuePhotoResponse: Codable {
    public let response: PhotoResponse
}

public struct PhotoResponse: Codable {
    public let photos: Photos?
}

public struct Photos: Codable {
    public let count: Int
    public let items: [Photo]
}

public struct Photo: Codable {
    public let id: String
    public let prefix: String
    public let suffix: String
    public let width: Int
    public let height: Int
    public let visibility: String
    public let source: Source
}

public struct Source: Codable {
    public let name: String?
    public let url: String?
}
