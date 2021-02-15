//
//  MapViewModelTests.swift
//  MapTests
//
//  Created by Sameh Mabrouk on 14/02/2021.
//

import XCTest
import RxSwift
import RxTest
import Utils
import Core
import FoursquareCore

@testable import Map

class MapViewModelTests: XCTestCase {
    
    // MARK: - Test variables

    private var sut: MapViewModel!
    private let useCaseMock = MapUseCase()
    private var disposeBag: DisposeBag!
    private var scheduler: TestScheduler!
    private let location = Location(lat: 1023456, lng: 1023456, address: "Prinsengraght", crossStreet: nil, distance: nil, postalCode: "1017 JH", cc: nil, city: "Amsterdam", state: nil, country: "The Netherlands")
    
    // MARK: - Test life cycle

    override func setUp() {
        super.setUp()
        
        sut = MapViewModel(useCase: useCaseMock)
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        sut = nil
        disposeBag = nil
        
        super.tearDown()
    }
    
    // MARK: - Tests

    func testInputLoaded() {
        // given
        let viewData = scheduler.createObserver((lat: Double, lng: Double).self)
        
        sut.outputs.showUserLocation
            .bind(to: viewData)
            .disposed(by: disposeBag)
        
        // when
        
        scheduler.createColdObservable([.next(10, .loaded)])
            .bind(to: sut.inputs.viewState)
            .disposed(by: disposeBag)
        
        useCaseMock.stubbedDetermineUserLocationResult = Observable.just(location)
        
        scheduler.start()
        
        // then
        let resultViewData = viewData.events.first?.value.element
        
        XCTAssertTrue(useCaseMock.invokedDetermineUserLocation)
        XCTAssertEqual(useCaseMock.invokedDetermineUserLocationCount, 1)
        
        XCTAssertEqual(resultViewData?.lat, location.lat)
    }
    
    func testObserverInputsLoadRestaurantsList() {
        // given
        let viewData = scheduler.createObserver([Venue].self)
        
        sut.outputs.showRestaurantsList
            .bind(to: viewData)
            .disposed(by: disposeBag)
        
        // when
        scheduler.createColdObservable([.next(10, ("1023456", "1023456"))])
            .bind(to: sut.inputs.restaurantsListAroundCoordinatedRequested)
            .disposed(by: disposeBag)
        
        let category = Category(id: "1", name: "Restaurant1", pluralName: "Restaurants", shortName: "Restaurant", icon: Category.Icon(prefix: nil, suffix: nil), primary: false)
        
        let venues = [Venue(id: "1", name: "Coffe Bru", contact: nil, location: location, categories: [category], verified: nil, url: nil, stats: nil, likes: nil, rating: nil, hours: nil, photos: nil, tips: nil)]
        
        useCaseMock.stubbedGetRestaurantsAroundResult = Observable.just((venues: venues, error: nil))
        
        scheduler.start()
        
        // then
        let resultViewData = viewData.events.first?.value.element
        
        XCTAssertTrue(useCaseMock.invokedGetRestaurantsAround)
        XCTAssertEqual(useCaseMock.invokedGetRestaurantsAroundCount, 1)
        
        XCTAssertEqual(resultViewData?.first?.name, "Coffe Bru")
    }
}
