//
//  AppConfig+Client.swift
//  ProjectX
//
//  Created by Sameh Mabrouk on 24/01/2021.
//  Copyright © 2021 Sameh Mabrouk. All rights reserved.
//

import FoursquareCore
import Core

extension AppConfig: FoursquareCoreConfigurable {
    public static var baseURL = Environment.string(for: .baseURL)
    public static var clientId = Environment.string(for: .clientId)
    public static var clientSecret = Environment.string(for: .clientSecret)
    public static var categoreyId = Environment.string(for: .categoryId)
}
