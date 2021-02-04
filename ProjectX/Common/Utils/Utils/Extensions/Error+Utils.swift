//
//  Error+Utils.swift
//  Utils
//
//  Created by Sameh Mabrouk on 02/02/2021.
//

import Foundation

public extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}
