//
//  TableViewSectionable.swift
//  Filters
//
//  Created by Sameh Mabrouk on 08/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import DesignSystem

public struct TableViewSection {
    public var items: [TableViewCellItemPresentable]
    public let title: String?
    
    public init(items: [TableViewCellItemPresentable], title: String? = nil) {
        self.items = items
        self.title = title
    }
}
