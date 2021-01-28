//
//  Category.swift
//  Core
//
//  Created by Sameh Mabrouk on 28/01/2021.
//

struct Category: Codable {
    let id: String
    let name: String
    let pluralName: String
    let shortName: String
    let icon: Icon
    struct Icon: Codable {
        let prefix: String?
        let suffix: String?
    }
    let primary: Bool?
}
