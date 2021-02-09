//
//  FloatingPoint+Utilities.swift
//  Utils
//
//  Created by Sameh Mabrouk on 08/02/2021.
//

public extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
