//
//  Double+toDate.swift
//  Utils
//
//  Created by Sameh Mabrouk on 12/02/2021.
//

import Foundation

public extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: date)
    }
}
