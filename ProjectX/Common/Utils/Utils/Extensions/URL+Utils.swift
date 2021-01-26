//
//  URL+Util.swift
//  Utils
//
//  Created by Sameh Mabrouk on 24/01/2021.
//

public extension URL {
    ///Pass a string without having to unwrap
    init(staticString string: String) {
        guard let url = URL(string: "\(string)") else {
            preconditionFailure("Invalid static URL string: \(string)")
        }
        
        self = url
    }
}
