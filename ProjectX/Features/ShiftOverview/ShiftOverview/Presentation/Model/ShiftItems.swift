//
//  RegularShiftItem.swift
//  ShiftOverview
//
//  Created by Sameh Mabrouk on 2/3/20.
//  Copyright © 2020 Temper. All rights reserved.
//

import Foundation
import Core
import Utils
import SwiftDate
import RxSwift

public protocol ShiftOverviewItem {}

public class RegularShiftItem: ShiftOverviewItem {
    let id: String?
    let jobId: String?
    let title: String
    let imageUrl: String
    let earningsPerHour: String
    let category: String
    let distance: String
    let duration: String
    let isAutoAcceptedWhenApplied: Bool
    let isHighChance: Bool

    init(withShift shift: FreeflexShift) {
        id = shift.id
        jobId = shift.job?.id
        title = shift.job?.project?.client?.name ?? ""
        imageUrl = shift.job?.heroImage ?? shift.job?.project?.client?.heroImage ?? ""
        category = shift.job?.category?.name ?? ""
        distance = String(Int(round(shift.distance ?? 0.0)))

        let startDate = shift.startsAt?.toDate(TemperDateFormat.yyyy_MM_dd_HH_mm_ssZ.rawValue, region: Region.getUserRegion())?.date
        let endDate = shift.endsAt?.toDate(TemperDateFormat.yyyy_MM_dd_HH_mm_ssZ.rawValue, region: Region.getUserRegion())?.date
        
        let startTimeString = startDate?.toString(dateFormat: .HH_mm) ?? ""
        let endTimeString = endDate?.toString(dateFormat: .HH_mm) ?? ""
        duration = "\(startTimeString) - \(endTimeString)"
        
        if let timeInterval = startDate?.timeIntervalSince(Date()),
            let applicantCount = shift.applicationsCount, let openPositions = shift.openPositions {
            isHighChance = timeInterval < 24 * 60 * 60 && applicantCount < openPositions
        } else {
            isHighChance = false
        }
        
        if let earningsAmount = shift.earningsPerHour?.amount, let currencySymbol = shift.earningsPerHour?.currency?.toCurrencySymbol() {
            earningsPerHour = "\(currencySymbol) \(earningsAmount.toLocalCurrency(decimalPlaces: 2, currencySymbol: ""))"
        } else {
            earningsPerHour = ""
        }
        isAutoAcceptedWhenApplied = shift.isAutoAcceptedWhenApplied ?? false
    }
}

public class LoadingItem: ShiftOverviewItem {
    init() {
    }
}

public class HeaderItem: ShiftOverviewItem {
    let date: String

    init(withDate date: String) {
        self.date = date
    }
}

struct BannerItem: ShiftOverviewItem {
    let title: String
    let subtitle: String
    let buttonTitle: String
    let icon: UIImage?
}

protocol EmptyStateable: ShiftOverviewItem {
    var date: String { get }
    var isSubscribed: Bool? { get set }
}

public class ResultsItem: EmptyStateable {
    let date: String

    var isSubscribed: Bool?
    
    init(withDate date: String) {
        self.date = date
    }
}

public class NoResultsItem: ResultsItem {}

public class EndOfResultsItem: ResultsItem {}
