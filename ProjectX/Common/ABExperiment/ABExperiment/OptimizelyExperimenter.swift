//
//  OptimizelyExperimenter.swift
//  OptimizelyWrapper
//
//  Created by Sameh Mabrouk on 25/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import Utils
import RxSwift

struct OptimizelyExperimenter: Experimenting {
    func activateExperiment(_ experiment: ExperimentName, userId: String) -> Observable<Any?> {
        // activateExperiment implementation goes here.
        return Observable<Any?>.just("variation")
    }
}
