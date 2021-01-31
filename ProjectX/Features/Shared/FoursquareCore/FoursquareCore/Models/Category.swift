//
//  Category.swift
//  Core
//
//  Created by Sameh Mabrouk on 28/01/2021.
//

public struct Category: Codable {
    
    public struct Icon: Codable {
        public let prefix: String?
        public let suffix: String?
    }
    
    public let id: String
    public let name: String
    public let pluralName: String
    public let shortName: String
    public let icon: Icon
    public let primary: Bool?
}
