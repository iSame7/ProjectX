//
//  Selectable.swift
//  Components
//
//  Created by Sameh Mabrouk on 01/04/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

public protocol Selectable {
    var id: String? { get set }
    var name: String? { get set }
    var isSelected: Bool { get set }
}
