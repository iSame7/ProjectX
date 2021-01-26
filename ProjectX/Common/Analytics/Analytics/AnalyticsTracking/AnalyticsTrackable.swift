//
//  AnalyticsTrackable.swift
//  AnalyticsEngine
//
//  Created by Sameh Mabrouk on 15/04/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

public protocol AnalyticsTrackable {
    var analyticsElementType: AnalyticsElementType { get }
    var analyticsElementId: AnalyticsElementId! { get }
    var analyticsParameters: AnalyticsParameters? { get }
}
extension AnalyticsTrackable {
    var analyticsParameters: [String: Any]? {
        return nil
    }
}

protocol AnalyticsSourceable: class {
    var analyticsSourceType: AnalyticsElementType? { get set }
    var analyticsSourceId: AnalyticsElementId? { get set }
}

extension AnalyticsSourceable {
    
    func setAnalyticsSource(_ source: AnalyticsTrackable) {
        analyticsSourceType = source.analyticsElementType
        analyticsSourceId = source.analyticsElementId
    }
}

private extension AnalyticsTrackable {
    
    func trackAnalyticsEvent(name: AnalyticsEvent.Name, dispatcher: AnalyticsDispatcher = .shared) {
        guard let analyticsElementId = analyticsElementId else {
            assertionFailure("[ANALYTICS] Tracking \(name.rawValue) event without analyticsElementId")
            return
        }
        
        let element = AnalyticsEvent.Element(type: analyticsElementType,
                                             id: analyticsElementId)
        var source: AnalyticsEvent.Element?
        if let self = self as? AnalyticsSourceable {
            guard let analyticsSourceType = self.analyticsSourceType, let analyticsSourceId = self.analyticsSourceId else {
                assertionFailure("[ANALYTICS] Tracking \(name.rawValue) event without source")
                return
            }
            
            source = AnalyticsEvent.Element(type: analyticsSourceType,
                                            id: analyticsSourceId)
        }
        
        let event = AnalyticsEvent(eventName: name,
                                   element: element,
                                   source: source,
                                   customParameters: analyticsParameters ?? [:])
        
        dispatcher.log(event: event, userId: nil)
    }
}

// MARK: - AnalyticsViewable

protocol AnalyticsViewable: AnalyticsTrackable {
    func trackViewEvent()
}
extension AnalyticsViewable {
    func trackViewEvent() {
        trackAnalyticsEvent(name: .view)
    }
}

// MARK: - AnalyticsTappable

protocol AnalyticsTappable: AnalyticsTrackable {
    func trackTapEvent()
}
extension AnalyticsTappable {
    func trackTapEvent() {
        trackAnalyticsEvent(name: .tap)
    }
}
