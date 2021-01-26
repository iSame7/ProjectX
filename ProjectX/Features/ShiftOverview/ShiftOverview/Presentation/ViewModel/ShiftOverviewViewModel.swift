//
//  ShiftOverviewViewModel.swift
//  Temper
//
//  Created by Sameh Mabrouk on 12/16/19.
//  Copyright © 2019 Temper B.V. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import DesignSystem
import Utils
import Core
import Filters
import UserNotifications

protocol ShiftOverviewViewModelInputs {
    var onTapItem: PublishSubject<ShiftOverviewItem> { get }
    var onTapFiltersButton: PublishSubject<Void> { get }
    
    func loadDataFor(container: ShiftOverviewDataContainer, indexPath: IndexPath)
    func toggleSubscriptionFor(date: Date)
    
    func startup() -> Observable<Filter>
}

protocol ShiftOverviewViewModelOutputs {
    var insertUpdate: PublishSubject<IndexPath> { get }
    var resetTableView: PublishSubject<Void> { get }
    var shiftApplied: PublishSubject<ShiftApplicationAlertType?> { get }
    var openUrlInBrowser: PublishSubject<URL> { get }
    var showInAppNotification: PublishSubject<(title: String, subtitle: String, emoji: Emoji)> { get }
    var showAlert: PublishSubject<(title: String, subtitle: String, actionTitle: String)> { get }
}

protocol ShiftOverviewViewModelProtocol: ViewModelType {
    var inputs: ShiftOverviewViewModelInputs { get }
    var outputs: ShiftOverviewViewModelOutputs { get }
    
    var showJobPage: PublishSubject<(jobId: String, shiftId: String)> { get }
    var showFilters: PublishSubject<Void> { get }
    var onFinishFilterCoordinator: PublishSubject<Filter?> { get }
    var hideBannerView: PublishSubject<Void> { get }
    var bannerCallToActionTapped: PublishSubject<Void> { get }
    
    var disposeBag: DisposeBag { get }
    var shouldShowBanner: Bool { get }
}

public class ShiftOverviewViewModel: ViewModelType, ShiftOverviewViewModelProtocol, ShiftOverviewViewModelOutputs {
    var showJobPage = PublishSubject<(jobId: String, shiftId: String)>()
    let showFilters = PublishSubject<Void>()
    var hideBannerView = PublishSubject<Void>()
    var bannerCallToActionTapped = PublishSubject<Void>()
    
    // MARK: - Action handlers
    let onTapItem = PublishSubject<ShiftOverviewItem>()
    let onTapFiltersButton = PublishSubject<Void>()
    
    private let analyticsDispatcher: AnalyticsDispatchable
    
    var onFinishFilterCoordinator = PublishSubject<Filter?>() {
        didSet {
            onFinishFilterCoordinator.subscribe(onNext: {  [weak self] filter in
                // reload table view with new data
                guard let filter = filter else { return }
                
                self?.shiftOverviewItems = []
                self?.setupData()
                
                self?.filter = filter
                
                self?.resetTableView.onNext(())
                
            }).disposed(by: disposeBag)
        }
    }
    
    // MARK: - In/Out
    var inputs: ShiftOverviewViewModelInputs { return self }
    var outputs: ShiftOverviewViewModelOutputs { return self }
    
    let disposeBag = DisposeBag()
    
    // MARK: Outputs
    var insertUpdate: PublishSubject<IndexPath> = PublishSubject<IndexPath>()
    var resetTableView = PublishSubject<Void>()
    var shiftApplied = PublishSubject<ShiftApplicationAlertType?>()
    var openUrlInBrowser = PublishSubject<URL>()
    var showInAppNotification = PublishSubject<(title: String, subtitle: String, emoji: Emoji)>()
    var showAlert = PublishSubject<(title: String, subtitle: String, actionTitle: String)>()
    
    // MARK: Class members
    public var shiftOverviewItems: [ShiftOverviewDataContainer] = []
    public var filter: Filter?
    public var subscribedDates: [Date] = []
    public var daysForDateScroller = 365
    private var bannerContainer: ShiftOverviewDataContainer! {
        didSet {
            if (shiftOverviewItems.first?.items.first as? BannerItem) != nil {
                shiftOverviewItems.removeFirst()
            }
            shiftOverviewItems.insert(bannerContainer, at: 0)
            resetTableView.onNext(())
        }
    }
    private var pushNotificationService = PushNotificationService()
    
    var shouldShowBanner: Bool {
        return bannerType != nil
    }
    
    // MARK: - UseCase
    private let useCase: ShiftOverviewInteractable
    private let filterCache: FilterCaching
    private var bannerType: ShiftOverviewBannerType?
    
    init(withUseCase useCase: ShiftOverviewInteractable, filterCache: FilterCaching, bannerType: ShiftOverviewBannerType?, analyticsDispatcher: AnalyticsDispatchable = AnalyticsDispatcher.shared) {
        self.useCase = useCase
        self.filterCache = filterCache
        self.bannerType = bannerType
        self.analyticsDispatcher = analyticsDispatcher
        
        setupObservers()
        
        setupData()
    }
}

private extension ShiftOverviewViewModel {
    
    func setupBanner(type: ShiftOverviewBannerType) {
        var bannerItem: BannerItem!
        
        if type == .howToStart {
            bannerItem = BannerItem(title: Localize.ShiftOverview.Banner.howToStart.title,
                                    subtitle: Localize.ShiftOverview.Banner.howToStart.subtitle,
                                    buttonTitle: Localize.ShiftOverview.Banner.howToStart.buttonTitle,
                                    icon: Emoji.party.toImage())
            bannerContainer = ShiftOverviewDataContainer(date: Date(), items: [bannerItem])
        } else {
            pushNotificationService.getPermissionStatus {[weak self] granted in
                guard let self = self else { return }
                
                if !granted {
                    bannerItem = BannerItem(title: Localize.ShiftOverview.Banner.notificationConsent.title,
                                            subtitle: Localize.ShiftOverview.Banner.notificationConsent.subtitle,
                                            buttonTitle: Localize.ShiftOverview.Banner.notificationConsent.buttonTitle,
                                            icon: Emoji.loudspeaker.toImage())
                    let date = Calendar.current.startOfDay(for: Date())
                    self.bannerContainer = ShiftOverviewDataContainer(date: date, items: [bannerItem])
                } else {
                    self.hideBannerView.onNext(())
                }
            }
        }
    }
    
    func setupData() {
        if shouldShowBanner {
            guard let bannerType = bannerType else { return }
            
            setupBanner(type: bannerType)
            self.analyticsDispatcher.log(event: AnalyticsEvent.bannerViewed(bannerType: bannerType.rawValue), userId: nil)
        }
        
        (0..<365).forEach { index in
            let date = Date().add(days: index)
            let container = ShiftOverviewDataContainer(date: date, items: [
                HeaderItem(withDate: date.toString(dateFormat: "EEEE d, MMMM")),
                LoadingItem(),
                LoadingItem(),
                LoadingItem(),
                LoadingItem(),
                LoadingItem(),
                LoadingItem(),
            ])
            
            self.shiftOverviewItems.append(container)
        }
        
        self.shiftOverviewItems.sort { (lhs, rhs) -> Bool in
            return lhs.date < rhs.date
        }
    }
    
    func setupObservers() {
        inputs.onTapFiltersButton.subscribe(onNext: { [unowned self] in
            self.showFilters.onNext(())
        }).disposed(by: disposeBag)
        
        inputs.onTapItem.subscribe { [unowned self] value in
            guard let shiftItem = value.element as? RegularShiftItem, let jobId = shiftItem.jobId, let shiftId = shiftItem.id else { return }
            
            self.showJobPage.onNext((jobId: jobId, shiftId: shiftId))
            
        }.disposed(by: disposeBag)
        
        hideBannerView.subscribe(onNext: { [unowned self] _ in
            self.hideBanner()
            self.analyticsDispatcher.log(event: AnalyticsEvent.bannerClosed(bannerType: self.bannerType?.rawValue ?? ""), userId: nil)
            self.resetTableView.onNext(())
        }).disposed(by: disposeBag)
        
        bannerCallToActionTapped.subscribe(onNext: { [weak self] _ in
            self?.tapBannnerCallToAction()
            self?.analyticsDispatcher.log(event: AnalyticsEvent.bannerCallToActionTapped(bannerType: self?.bannerType?.rawValue ?? ""), userId: nil)
        }).disposed(by: disposeBag)
        
        shiftApplied.subscribe(onNext: { [weak self] shiftApplicationAlertType in
            self?.hideBannerView.onNext(())
            guard let shiftApplicationAlertType = shiftApplicationAlertType else { return }
            
            switch shiftApplicationAlertType {
            case .inAppNotification(let appliedCount):
                self?.showInAppNotification.onNext((title: Localize.ShiftOverview.Notification.ApplicationSuccess.title(forAppliedCount: appliedCount),
                                                    subtitle: Localize.ShiftOverview.Notification.ApplicationSuccess.message, emoji: .okHand))
            case .conflictingApplication:
                self?.showAlert.onNext((title: Localize.ShiftOverview.Alert.ConflictingShift.title, subtitle:
                    Localize.ShiftOverview.Alert.ConflictingShift.subtitle, actionTitle: Localize.ShiftOverview.Alert.actionTitle))
            case .multipleShifts(let blocked, let appliedCount):
                if let blockedShiftInfo = blocked?.joined(separator: "\n") {
                    self?.showAlert.onNext((title: Localize.ShiftOverview.Alert.MultipleShifts.title, subtitle: blockedShiftInfo,
                    actionTitle: Localize.ShiftOverview.Alert.actionTitle))
                }
                if let appliedCount = appliedCount, appliedCount > 0 {
                    self?.showInAppNotification.onNext((title: Localize.ShiftOverview.Notification.ApplicationSuccess.title(forAppliedCount: appliedCount),
                    subtitle: Localize.ShiftOverview.Notification.ApplicationSuccess.message, emoji: .okHand))
                }
                
            default:
                self?.showAlert.onNext((title: Localize.ShiftOverview.Alert.CouldNotApply.title, subtitle: "",
                                        actionTitle: Localize.ShiftOverview.Alert.actionTitle))
            }
        }).disposed(by: disposeBag)
    }
    
    func tapBannnerCallToAction() {
        guard let bannerType = bannerType else { return }
        
        switch bannerType {
        case .howToStart:
            guard let targetUrl = URL(string: Localize.ShiftOverview.Banner.howToStart.targetUrl) else { return }
            self.openUrlInBrowser.onNext(targetUrl)
        case .notificationConsent:
            if !pushNotificationService.pushNotificationPermissionGranted {
                pushNotificationService.requestAuthorization { _ in
                    self.hideBannerView.onNext(())
                }
            }
        }
    }
    
    func hideBanner() {
        guard let container = self.bannerContainer, let indexOfContainer = self.shiftOverviewItems.firstIndex(where: { $0 == container }) else { return }
        
        self.shiftOverviewItems.remove(at: indexOfContainer)
        self.bannerType = nil
    }

}

extension ShiftOverviewViewModel: ShiftOverviewViewModelInputs {
    
    func startup() -> Observable<Filter> {
        
        return Observable.zip(useCase.getFilter(), useCase.loadUserPrefferedDates()).flatMap { result -> Observable<Filter> in
            let (filter, dates) = result
            
            if let dates = dates as? [Date] {
                self.subscribedDates = dates
            }
            
            return Observable.just(filter)
            
        }
    }
    
    func loadDataFor(container: ShiftOverviewDataContainer, indexPath: IndexPath) {
        
        let date = container.date
        
        self.useCase.loadShifts(forDates: [date], withFilters: filter)
            .subscribe { event in
                
                guard let shifts = event.element,
                    let newContainer = shifts.first,
                    let existingContainerIndex = self.shiftOverviewItems.firstIndex(of: container) else {
                        return
                }
                
                self.shiftOverviewItems.remove(at: existingContainerIndex)
                
                self.shiftOverviewItems.insert(newContainer, at: existingContainerIndex)
                
                self.insertUpdate.onNext(indexPath)
                
                self.warmupFilterCacheIfRequired()
                
        }.disposed(by: disposeBag)
    }
}

// MARK: - Preffered date subscriptions
public extension ShiftOverviewViewModel {
    func toggleSubscriptionFor(date: Date) {
        let isSubscribed = containsSubscriptionForDate(date: date)
        
        if !isSubscribed {
            useCase.subscribeToWorkOnDate(date: date)
                .subscribe()
                .disposed(by: disposeBag)
            
            subscribedDates.append(date)
            
            return
        }
        
        useCase.unsubscribeToWorkOnDate(date: date)
            .subscribe()
            .disposed(by: disposeBag)
        
        subscribedDates.removeAll { (existingDate) -> Bool in
            return existingDate.dateAtStartOf(.day) == date.dateAtStartOf(.day)
        }
    }
    
    func containsSubscriptionForDate(date: Date) -> Bool {
        return subscribedDates.contains { (lhsDate) -> Bool in
            lhsDate.dateAtStartOf(.day) == date.dateAtStartOf(.day)
        }
    }
}

private extension ShiftOverviewViewModel {
    
    func warmupFilterCacheIfRequired() {
        // If cache for filters is empty, warm it
        // Warm up cache for preferences
        
        if filterCache.preferences == nil {
            
            self.useCase.getFilterPreferences().subscribe { result in
                guard result.element != nil else {
                    return
                }
            }.disposed(by: self.disposeBag)
        }
    }
}
