//
//  Delivery.swift
//  Core
//
//  Created by Sameh Mabrouk on 28/01/2021.
//

struct Delivery: Codable {
    let id: String?
    let url: String?
    let provider: Provider?
    struct Provider: Codable {
        let name: String?
    }
}
