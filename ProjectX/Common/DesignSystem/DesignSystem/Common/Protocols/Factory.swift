//
//  Factory.swift
//  DesignSystem
//
//  Created by Sameh Mabrouk on 25/01/2021.
//

import Foundation
import UIKit

public protocol Factory: class {
    associatedtype ComponentType
    var playbookPresentationSize: CGRect { get }
    func build() -> ComponentType
}
