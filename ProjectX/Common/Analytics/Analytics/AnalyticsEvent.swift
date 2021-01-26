//
//  AnalyticsEvent.swift
//  Analytics
//
//  Created by Sameh Mabrouk on 26/01/2021.
//

struct AnalyticsEvent {
    enum Name: String {
        case deepLink
        case input
        case request
        case response
        case share
        case tap
        case view
    }
    
    struct Element {
        let type: AnalyticsElementType
        let id: AnalyticsElementId
    }
    
    let eventName: Name
    let element: Element
    let source: Element?
    
    let customParameters: AnalyticsParameters
}

// MARK: - AnalyticsLoggable

extension AnalyticsEvent: AnalyticsLoggable {
    
    var name: String {
        return eventName.rawValue
    }
    
    var longEventName: String {
        return [eventName.rawValue, element.type.rawValue, element.id.rawValue].compactMap({ $0 }).joined(separator: "-")
    }
    
    var fullEventName: String {
        return [eventName.rawValue, element.type.rawValue, element.id.rawValue, source?.type.rawValue, source?.id.rawValue].compactMap({ $0 }).joined(separator: "-")
    }
    
    var parameters: AnalyticsParameters {
        let eventParameters = [
            "element_type": element.type.rawValue,
            "element_id": element.id.rawValue,
            "source_type": source?.type.rawValue,
            "source_id": source?.id.rawValue,
            "event_name_long": longEventName,
            "event_name_full": fullEventName
        ].compactMapValues { $0 } as AnalyticsParameters
        
        // Don't allow custom parameters to overwrite event parameters
        return eventParameters.merging(customParameters) { (eventValue, _) in
            return eventValue
        }
    }
    
    var requiredForMarketing: Bool {
        return element.id.requiredForMarketing
    }
}
