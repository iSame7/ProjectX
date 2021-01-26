//
//  ExperimentsDispatcher.swift
//  OptimizelyWrapper
//
//  Created by Sameh Mabrouk on 25/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import RxSwift

public class ExperimentsDispatcher {
    
    public static let shared = ExperimentsDispatcher(experimenters: [OptimizelyExperimenter()])
    
    private var experiments = [ExperimentName: Experimentable]()
    private let experimenters: [Experimenting]
    private let disposeBag = DisposeBag()
    
    public init(experimenters: [Experimenting]) {
        self.experimenters = experimenters
    }
    
    public func activateExperiments(experiments: [Experimentable] = [], userId: String) {
        experiments.forEach {
            self.experiments[$0.name] = $0
            activate($0, userId: userId)
        }
    }
    
    public func experiment(for name: ExperimentName) -> Experimentable? {
        return experiments[name]
    }
    
    private func activate(_ experiment: Experimentable, userId: String) {
        experimenters.forEach {
            $0.activateExperiment(experiment.name, userId: userId).subscribe(onNext: { [weak self] value in
                self?.experiments[experiment.name]?.remoteValue = value
            }).disposed(by: disposeBag)
        }
    }
}
