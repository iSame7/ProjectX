//
//  AnimationTiming.swift
//  Components
//
//  Created by Sameh Mabrouk on 24/05/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

enum AnimationTiming {
    case easeIn
    case easeOut
    case easeInOut
    case spring (velocity: CGVector)

    var curve: UITimingCurveProvider {
        switch self {
        case .easeIn:
            return UICubicTimingParameters(controlPoint1: CGPoint(x: 0.5, y: 0), controlPoint2: CGPoint(x: 1, y: 1))
        case .easeOut:
            return UICubicTimingParameters(controlPoint1: CGPoint(x: 0, y: 0), controlPoint2: CGPoint(x: 0.4, y: 1))
        case .easeInOut:
            return UICubicTimingParameters(controlPoint1: CGPoint(x: 0.45, y: 1), controlPoint2: CGPoint(x: 0.4, y: 1))
        case .spring(let velocity):
            return UISpringTimingParameters(mass: 1.8, stiffness: 330, damping: 33, initialVelocity: velocity)
        }
    }
}
