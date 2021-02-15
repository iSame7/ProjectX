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
        
        public init(prefix: String?, suffix: String?) {
            self.prefix = prefix
            self.suffix = suffix
        }
    }
    
    public let id: String
    public let name: String
    public let pluralName: String
    public let shortName: String
    public let icon: Icon
    public let primary: Bool?
    
    public init(id: String, name: String, pluralName: String, shortName: String, icon: Icon, primary: Bool?) {
        self.id = id
        self.name = name
        self.pluralName = pluralName
        self.shortName = shortName
        self.icon = icon
        self.primary = primary
    }
}

