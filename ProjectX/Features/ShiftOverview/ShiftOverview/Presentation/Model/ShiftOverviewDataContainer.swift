//
//  ShiftOverviewDataContainer.swift
//  ShiftOverview
//
//  Created by Sameh Mabrouk on 26/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import Foundation

public struct ShiftOverviewDataContainer: Equatable {
    public static func == (lhs: ShiftOverviewDataContainer, rhs: ShiftOverviewDataContainer) -> Bool {
        return lhs.date == rhs.date
    }
    
    let date: Date
    let items: [ShiftOverviewItem]
    
    init(date: Date, items: [ShiftOverviewItem]) {
        self.date = date
        self.items = items
    }
}
