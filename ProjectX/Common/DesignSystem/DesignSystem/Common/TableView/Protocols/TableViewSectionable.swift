//
//  TableViewSectionable.swift
//  Components
//
//  Created by Sameh Mabrouk on 11/08/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

public protocol TableViewSectionable {
    var title: String? { get }
    var subtitle: String? { get }
    var items: [TableViewCellItemPresentable] { get set }
    var sectionType: Any? { get }
}
