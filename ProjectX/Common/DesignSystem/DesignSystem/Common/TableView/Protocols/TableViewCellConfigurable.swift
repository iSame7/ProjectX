//
//  TableViewCellConfigurable.swift
//  Filters
//
//  Created by Sameh Mabrouk on 09/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import UIKit

protocol TableViewCellConfigurable: UITableViewCell {
    func configure(with model: TableViewCellItemPresentable)
}
