//
//  Localize.swift
//  Filters
//
//  Created by Sameh Mabrouk on 24/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import Utils

extension Localize {
    enum Filters {
        static let title = Localize.tr("filters.title")
        
        enum Table {
            enum Section {
                static let categories = Localize.tr("filters.table.section.categories")
                static let location = Localize.tr("filters.table.section.location")
                enum Location {
                    enum Cell {
                        static let distance = Localize.tr("filters.table.section.cell.location.distance")
                    }
                }
            }
        }
        enum Button {
            static let resetFilters = Localize.tr("filters.button.resetFilters")
            static let apply = Localize.tr("filters.button.apply")
        }
    }
    enum FilterCategories {
        enum Button {
            static let selectAll = Localize.tr("filtersCategory.button.selectAll")
            static let deselectAll = Localize.tr("filtersCategory.button.deselectAll")
        }
    }
}

extension Localize {
    private static func tr(_ key: String, _ args: CVarArg...) -> String {
        return Localize.localize(key, Bundle(for: BundleToken.self), args)
    }
}

private final class BundleToken {}
