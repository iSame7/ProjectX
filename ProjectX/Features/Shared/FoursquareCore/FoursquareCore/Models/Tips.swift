//
//  Tips.swift
//  Core
//
//  Created by Sameh Mabrouk on 28/01/2021.
//

struct TipsRespose: Codable {
    let tips: [Tip]
}

struct Tip: Codable {
    let createdAt: String
    let text: String
    let userName: String
}

struct Stats: Codable {
    let tipCount: Int?
    let usersCount: Int?
    let checkinsCount: Int?
    let visitsCount: Int64?
}

struct Likes: Codable {
    let count: Int
}
