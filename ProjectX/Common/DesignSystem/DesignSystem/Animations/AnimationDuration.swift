//
//  AnimationDuration.swift
//  Components
//
//  Created by Sameh Mabrouk on 24/05/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

enum AnimationDuration: TimeInterval {
    case microFast = 0.1
    case microRegular = 0.2
    case microSlow = 0.3

    case macroFast = 0.4
    case macroRegular = 0.5
    case macroSlow = 0.6
    
    var timeInterval: TimeInterval {
        return rawValue
    }
}
