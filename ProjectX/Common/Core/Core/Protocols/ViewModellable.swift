//
//  ViewModellable.swift
//  Core
//
//  Created by Sameh Mabrouk on 02/09/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import RxSwift

public protocol ViewModellable {
    var disposeBag: DisposeBag { get }
}
