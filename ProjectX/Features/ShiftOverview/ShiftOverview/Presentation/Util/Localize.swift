//
//  Localize.swift
//  ShiftOverview
//
//  Created by Sameh Mabrouk on 26/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import Utils

extension Localize {
    enum ShiftOverview {
        static let title = Localize.tr("shiftOverview.title")
        
        enum Banner {
            enum howToStart {
                static let title = Localize.tr("shiftOverview.banner.howToStart.title")
                static let subtitle = Localize.tr("shiftOverview.banner.howToStart.subtitle")
                static let buttonTitle = Localize.tr("shiftOverview.banner.howToStart.buttonTitle")
                static let targetUrl = Localize.tr("shiftOverview.banner.howToStart.button.targetUrl")
            }
            
            enum notificationConsent {
                static let title = Localize.tr("shiftOverview.banner.notificationConsent.title")
                static let subtitle = Localize.tr("shiftOverview.banner.notificationConsent.subtitle")
                static let buttonTitle = Localize.tr("shiftOverview.banner.notificationConsent.buttonTitle")
            }
        }
        
        enum Table {
            enum Cell {
                enum shiftoverview {
                    static let highChance = Localize.tr("shiftOverview.table.cell.shiftoverview.highChance")
                }
                
                enum noResult {
                    static let keepMeUpdated = Localize.tr("shiftOverview.table.cell.noResult.keepMeUpdate")
                    static let stopUpdatingMe = Localize.tr("shiftOverview.table.cell.noResult.stopUpdatingMe")
                    static let thereAreNoShiftsAvailable = Localize.tr("shiftOverview.table.cell.noResult.thereAreNoShiftsAvailable")
                    static let doYouWantToBeKeptInformedByEmail = Localize.tr("shiftOverview.table.cell.noResult.doYouWantToBeKeptInformedByEmail")
                }
            }
        }
        enum Button {
            static let filters = Localize.tr("shiftOverview.button.filter")
        }
        enum Notification {
            enum ApplicationSuccess {
                static func title(forAppliedCount count: Int) -> String {
                    return Localize.tr("shiftOverview.notification.applicationSuccess.title", count)
                }
                static let message = Localize.tr("shiftOverview.notification.applicationSuccess.message")
            }
        }
        enum Alert {
            enum ConflictingShift {
                static let title = Localize.tr("shiftOverview.alert.conflictingShift.title")
                static let subtitle = Localize.tr("shiftOverview.alert.conflictingShift.subtitle")
            }
            enum MultipleShifts {
                static let title = Localize.tr("shiftOverview.alert.multipleShifts.title")
            }
            enum CouldNotApply {
                static let title = Localize.tr("shiftOverview.alert.couldNotApply.title")
            }
            static let actionTitle = Localize.tr("shiftOverview.alert.actionTitle")
        }
    }
}
extension Localize {
    private static func tr(_ key: String, _ args: CVarArg...) -> String {
        return Localize.localize(key, Bundle(for: BundleToken.self), args)
    }
}

private final class BundleToken {}
