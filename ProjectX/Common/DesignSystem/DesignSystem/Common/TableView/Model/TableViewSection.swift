//
//  TableViewSection.swift
//  Components
//
//  Created by Sameh Mabrouk on 11/08/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

public struct TableViewSection: TableViewSectionable {
    public var items: [TableViewCellItemPresentable]
    public let title: String?
    public let subtitle: String?
    public let sectionType: Any?
    
    public init(title: String? = nil, subtitle: String? = nil, items: [TableViewCellItemPresentable], sectionType: Any? = nil) {
        self.title = title
        self.subtitle = subtitle
        self.items = items
        self.sectionType = sectionType
    }
}
