//
//  UniversalLinksRoutes.swift
//  Temper
//
//  Created by Sameh Mabrouk on 01/09/2020.
//  Copyright © 2020 Temper B.V. All rights reserved.
//

/// List of supported universal links in Freeflexer app 
enum UniversalLinksRoutes: String {
    case magicLink = "login/magic-link/{magic_link}"
    case shiftOverview = "werk-zoeken"
    case jobPage = "werken-bij/{client}/{jobcategory}/{job}"
}
