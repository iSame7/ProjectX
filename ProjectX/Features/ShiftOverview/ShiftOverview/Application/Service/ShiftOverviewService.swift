//
//  ShiftOverviewService.swift
//  Temper
//
//  Created by Sameh Mabrouk on 1/16/20.
//  Copyright © 2020 Temper B.V. All rights reserved.
//

import Foundation
import RxSwift
import Core
import Utils
import Filters

protocol ShiftOverviewServiceFetching {
    func getShifts(forDate date: Date, with filter: Filter?) -> Observable<(date: Date, shifts: [FreeflexShift])>
    func subscribeToWorkOnDate(date: Date) -> Observable<Void>
    func unsubscribeToWorkOnDate(date: Date) -> Observable<Void>
    func getUserPrefferedDates() -> Observable<[Date?]>
}

class ShiftOverviewService: ShiftOverviewServiceFetching {
    
    func getShifts(forDate date: Date, with filter: Filter?) -> Observable<(date: Date, shifts: [FreeflexShift])> {
        // getShifts implementation goes here.
        return .empty()
    }
    
    func subscribeToWorkOnDate(date: Date) -> Observable<Void> {
        // subscribeToWorkOnDate implemenation goes here.
        return .empty()
    }
    
    func unsubscribeToWorkOnDate(date: Date) -> Observable<Void> {
        // unsubscribeToWorkOnDate implemenation goes here.
        return .empty()
    }
    
    func getUserPrefferedDates() -> Observable<[Date?]> {
        // getUserPrefferedDates implementation goes here.
        return .empty()
    }
}
