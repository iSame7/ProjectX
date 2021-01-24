//
//  AppConfig+Client.swift
//  ProjectX
//
//  Created by Sameh Mabrouk on 24/01/2021.
//  Copyright © 2021 Sameh Mabrouk. All rights reserved.
//

import Core

extension AppConfig: CoreConfigurable {
    public static var baseURL = Environment.string(for: .baseURL)
}
