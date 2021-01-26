//
//  Experimenting.swift
//  OptimizelyWrapper
//
//  Created by Sameh Mabrouk on 25/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import RxSwift

public protocol Experimenting {
    func activateExperiment(_ experiment: ExperimentName, userId: String) -> Observable<Any?> 
}
