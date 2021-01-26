//
//  Localize.swift
//  Location
//
//  Created by Sameh Mabrouk on 15/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import Utils

extension Localize {
    enum Location {
        static let title = Localize.tr("location.title")
        
        enum Table {
            enum Cell {
                static let currentLocation = Localize.tr("location.table.cell.currentLocation")
            }
            enum SearchBar {
                static let placeholder = Localize.tr("location.table.searchBar.placeholder")
            }
        }
    }
}

extension Localize {
    private static func tr(_ key: String, _ args: CVarArg...) -> String {
        return Localize.localize(key, Bundle(for: BundleToken.self), args)
    }
}

private final class BundleToken {}
