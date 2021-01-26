//
//  Localize.swift
//  Utils
//
//  Created by Sameh Mabrouk on 24/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

public enum Localize {}

public extension Localize {
    static func localize(_ key: String, table: String = "Localizable", _ bundle: Bundle, _ args: [CVarArg]) -> String {
        let format = NSLocalizedString(key, tableName: table, bundle: bundle, comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}
