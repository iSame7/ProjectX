//
//  Tips.swift
//  Core
//
//  Created by Sameh Mabrouk on 28/01/2021.
//

public struct TipsRespose: Codable {
    public let tips: [Tip]
}

public struct Tip: Codable {
    public let createdAt: String
    public let text: String
    public let userName: String
}

public struct Stats: Codable {
    public let tipCount: Int?
    public let usersCount: Int?
    public let checkinsCount: Int?
    public let visitsCount: Int64?
}

public struct Likes: Codable {
    public let count: Int
}
