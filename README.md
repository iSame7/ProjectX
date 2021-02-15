# ProjectX
========================

[![Platform](http://img.shields.io/badge/platform-ios-blue.svg?style=flat
)](https://developer.apple.com/iphone/index.action)
[![Language](http://img.shields.io/badge/language-swift-brightgreen.svg?style=flat
)](https://developer.apple.com/swift)
[![License](http://img.shields.io/badge/license-MIT-lightgrey.svg?style=flat
)](http://mit-license.org)

## Overview

This repository contains some iOS code samples. 

- The architecture that underpins the development of the apps can be found [here](https://github.com/iSame7/ProjectX/blob/master/Technical-Documents/Architecture.md)
- Sharing configurations between modules implementation can be found [here](https://github.com/iSame7/ProjectX/tree/master/ProjectX/Common/Core/Core/Configs)
- A feature implementation can be found [here](https://github.com/iSame7/ProjectX/tree/master/ProjectX/Features/ShiftOverview)
- Universal links implementation can be found [here](https://github.com/iSame7/ProjectX/tree/master/ProjectX/Common/Core/Core/UniversalLinks)
- A/B experimenter implementation can be found [here](https://github.com/iSame7/ProjectX/tree/master/ProjectX/Common/ABExperiment/ABExperiment)
- Analytics implementation can be found [here](https://github.com/iSame7/ProjectX/tree/master/ProjectX/Common/Analytics/Analytics)
- iOS Foursquare client that display the restaurants around your current location on the
map. Developed using Swift, VIPER.

<img src="/Assets/Foursquare.gif" alt="Screenshot" width="320px"/>
<img src="/Assets/map.png" alt="Screenshot" width="320px"/>
<img src="/Assets/details.png" alt="Screenshot" width="320px"/>
<img src="/Assets/details1.png" alt="Screenshot" width="320px"/>
<img src="/Assets/gallery.png" alt="Screenshot" width="320px"/>
<img src="/Assets/tips.png" alt="Screenshot" width="320px"/>

## App Description

Using this application, a user should be able to see the restaurant around his/her current location. The data is available by connecting to the Foursquare API https://developer.foursquare.com/.

**App use cases**

*Map*:

- In this screen, the app shows a map with restaurant aroud a user's current location. this screen has a handy collection view that contain all the venues/restaurants, each item in the collection view has a name, image, venue category and distance to that venue. user can press that item to go to venue details screen. if a user swipe the collection view horizontally the app will select the specific annotation for the venue on the map and it works the other way around, if a user select a venue annotation form the map the collection view will scroll to that specific item/venue. 

*Details*:

- When tapping an item from map screen, user should be able to see deetails screen that has some informations about the selected venue. it has a beautiful UItableView steaky header/Parralax view and some details like venue rating, address, photos, tips. 

* Note: due to Foursquare API rate limiting based on the account type which is free in this case we only get 1 tip, and no details like usersCount,checkinsCount and visitsCount wo some details will be missing in the Rating cell. 

*Tips*:

- When tapping an item from tips list, user should see tips screen presented with a beautifl animation like the App store app transitions. each tip has a user name, photo, created date and text. this tips screen also has a steacky/parallax view for UITableView.

**Features**
* Request retrier: if a request fail due to server error the app will retry that request again for 3 times each 1 second. Thanks to Alamofire's RequestRetrier, please check NetworkRequestRetrier. 

* Rechability checker: if the device was offline and the app faild to make a request it will show in-app message to warn the user that there is not internet connection. once the device is online again the app automatically will retry the request. 

* Image viewer: if a venue has photos in the details screen user wil be able to browse these photos with cool animations/transitions.

* Map panning: App will load more restaurants by panning on the map.

**Improvements**
* Increase unit test code coverage
* Add loading state for details screen by using shimmer effect something like that:
[LoadingShimmer](https://github.com/jogendra/LoadingShimmer)
* Add navigation bar to details screen with nice little animation when scrolling table view. 
* optimize map screen to work more somthly with LOTS OF annotations.

## Installation

Just clone the repo or download it in zip-file, Open the project in Xcode, switch `ProjectX` Scheme then test it on your iOS device or iOS simulator.

In case you want to change the project setup like Foursquare API keys:

* Get your own keys from https://developer.foursquare.com/docs/api
* Change CLIENT_ID, CLIENT_SECRET user defined keys in the project's build settings as shown below:
<img src="/Assets/config.png" alt="Screenshot" width="320px"/>



# Xcode Project files structure
```bash
.swift
+-- Common
|   +-- Core
|   +-- DesignSystem
|   +-- Utils
+-- Features
|   +-- Map
    |   +-- Builder
            |   +-- MapModuleBuilder.swift
    |   +-- Coordinator
            |   +-- MapCoordinator.swift
    |   +-- Service
            |   +-- MapService.swift
            |   +-- LocationService.swift
    |   +-- UseCase
            |   +-- MapUseCase.swift
    |   +-- View
            |   +-- MapViewController.swift
            |   +-- CollectionViewCell.swift            
            |   +-- MapViewController+UICollectionView.swift            
    |   +-- ViewModel
            |   +-- MapViewModel.swift
|   +-- VenueDetails
|   +-- Tips
         
+-- ProjectX
+-- Pods
```

# Design Patterns used:

Check the architecture that underpins the development of the apps in this repository [here](https://github.com/iSame7/ProjectX/blob/master/Technical-Documents/Architecture.md)

# VIPER Architecture design pattern:

**What is VIPER?**
VIPER is an application of Clean Architecture to iOS apps. The word VIPER is a backronym for View, Interactor, Presenter, Entity, and Routing. Clean Architecture divides an app’s logical structure into distinct layers of responsibility. This makes it easier to isolate dependencies (e.g. your database) and to test the interactions at the boundaries between layers:
<img src="/Assets/VIPER.components.png" height="335" />

- Know more about VIPER through this post http://www.objc.io/issue-13/viper.html

**Why VIPER**:

*Smaller files*:

- VIPER (without a few exceptions:) ) has very clear politics about responsibility for each component. It helps with reducing amount of code in files and putting into the right place according to a single responsibility principle. 

*Better code coverage*: 

- Smaller classes mean smaller test cases as well. Tests resort less to exotic tricks and are simpler to read. The barrier to entry to write unit tests is lower, so more developers write them. 

*Good for unit testing*:

- On the basis of VIPER principles, everything in one module is very well separated, so it creates good environment for unit testing. Look at [this](http://iosunittesting.com/tdd-with-viper/?utm_source=swifting.io) article regarding more info about TDD in VIPER.

**VIPER modules Generator** : 

If you really want to make your application based on VIPER architecture, do not even think to make it all manually. It will be a disaster! You need an automated process to create a new module.

By the way I've created an opens source tool that automate the process of generating VIPER modules. A simple OS X App for generating VIPER modules's skeleton to use them in your Objective-C/Swift projects.
You can download it now:

* [ViperCode](https://github.com/iSame7/ViperCode)
* [VIPER-Module](https://github.com/iSame7/VIPER-Module)

# Dependency Injection:

Use of VIPER architecture gives great possibility to apply dependency injection. For example, let’s consider an example of a presenter:

```swift
class MapViewModel: MapViewModellable {
    
    let disposeBag = DisposeBag()
    let inputs = MapViewModelInputs()
    let outputs = MapViewModelOutputs()
    var useCase: MapInteractable
    
    init(useCase: MapInteractable) {
        self.useCase = useCase
        
        setupObservables()
    }
}

// MARK: - Observables

private extension MapViewModel {
    
    func setupObservables() {
        observeInputs()
    }
    
    func observeInputs() {
        inputs.viewState.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loaded:
                self.useCase.determineUserLocation().subscribe { event in
                    guard let location = event.element else { return }
                    self.outputs.showUserLocation.onNext((location.lat, location.lng))
                }.disposed(by: self.disposeBag)
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        inputs.restaurantsListAroundCoordinatedRequested.subscribe { [weak self] (lat, lng) in
            guard let self = self else { return }

            let coordinate = "\(lat),\(lng)"
            self.useCase.getRestaurantsAround(coordinates: coordinate).subscribe({ event in
                guard let result = event.element else { return }
                
                if let venues = result.venues {
                    self.outputs.showRestaurantsList.onNext(venues)
                } else if let error = result.error {
                    self.outputs.showError.onNext(error)
                }
                
            }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
```

Injection in this class gave us two advantages:

* We have a better sense what’s going on in this code. We see immediately what dependencies our class has
* On the other hand, our class is prepared for unit testing

*When using VIPER architecture a good practice is to use DI in every component. i will show in Unit Test section a few examples how this approach can really help us during testing.


# Unit testing:

I started from testing interactor and presenter, because interactor contains main business logic and presenter contains logic responsible for preparing data before displaying. These components seems more critical than others.

Libraries/Frameworks i used for unit tests and TDD:

* XCTest


Every module is strictly separated what creates a very friendly scenario for adopting unit tests in terms of single responsibility principle:

let’s consider an example of a presenter of List Characters Module:

by separating components in our test we can focus only on testing responsibility of interactor. The others components which talk with interactor are just mocked.

How does it look like in perspective of code?

```swift
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

class MapUseCase: MapInteractable {
    
    var invokedGetRestaurantsAround = false
    var invokedGetRestaurantsAroundCount = 0
    var invokedGetRestaurantsAroundParameters: (coordinates: String, Void)?
    var invokedGetRestaurantsAroundParametersList = [(coordinates: String, Void)]()
    var stubbedGetRestaurantsAroundResult: Observable<(venues: [Venue]?, error: FoursquareError?)>!
    func getRestaurantsAround(coordinates: String) -> Observable<(venues: [Venue]?, error: FoursquareError?)> {
        invokedGetRestaurantsAround = true
        invokedGetRestaurantsAroundCount += 1
        invokedGetRestaurantsAroundParameters = (coordinates, ())
        invokedGetRestaurantsAroundParametersList.append((coordinates, ()))
        return stubbedGetRestaurantsAroundResult
    }
    
    var invokedDetermineUserLocation = false
    var invokedDetermineUserLocationCount = 0
    var stubbedDetermineUserLocationResult: Observable<Location>!
    func determineUserLocation() -> Observable<Location> {
        invokedDetermineUserLocation = true
        invokedDetermineUserLocationCount += 1
        return stubbedDetermineUserLocationResult
    }
    
    var invokedGetVenuesPhotos = false
    var invokedGetVenuesPhotosCount = 0
    var invokedGetVenuesPhotosParameters: (venueId: String, Void)?
    var invokedGetVenuesPhotosParametersList = [(venueId: String, Void)]()
    var stubbedGetVenuesPhotosResult: Observable<[Photo]?>!
    func getVenuesPhotos(venueId: String) -> Observable<[Photo]?> {
        invokedGetVenuesPhotos = true
        invokedGetVenuesPhotosCount += 1
        invokedGetVenuesPhotosParameters = (venueId, ())
        invokedGetVenuesPhotosParametersList.append((venueId, ()))
        return stubbedGetVenuesPhotosResult
    }
}
```
