//
//  CustomTableViewCellViewable.swift
//  Components
//
//  Created by Sameh Mabrouk on 3/24/20.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

public protocol CustomTableViewCellViewable: UIView {
    func configure(with model: TableViewCellItemPresentable)
}
