//
//  NetworkRouter.swift
//  Core
//
//  Created by Sameh Mabrouk on 28/01/2021.
//

import Alamofire

public enum Router: URLRequestConvertible {
    case fetchRestaurants(coordinates: String)
    case fetchPhotos(venueId: String)
    case fetchVenueDetails(venueId: String)
    
    static let baseURLString = Config.baseURL
    
    var method: HTTPMethod {
        switch self {
        case .fetchRestaurants, .fetchPhotos, .fetchVenueDetails:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchRestaurants:
            return "/venues/search"
        case let .fetchPhotos(venueId):
            return "/venues/\(venueId)/photos"
        case let .fetchVenueDetails(venueId):
            return "/venues/\(venueId)"
        }
    }
    
    var parameters: [String: AnyObject]? {
        switch self {
        case let .fetchRestaurants(coordinates):
            let authorizationParams = getAuthorizationParameters()
            let params = ["ll": coordinates, "client_id" :  authorizationParams.0 , "client_secret": authorizationParams.1, "categoryId": "4d4b7105d754a06374d81259", "v": authorizationParams.2]
            return params as [String : AnyObject]?
        case .fetchPhotos, .fetchVenueDetails:
            let authorizationParams = getAuthorizationParameters()
            let params = ["client_id" :  authorizationParams.0 , "client_secret": authorizationParams.1, "v": authorizationParams.2]
            return params as [String : AnyObject]?
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        print("URL: \(String(describing: urlRequest.url))")
        return urlRequest
    }
    
    func getAuthorizationParameters() -> (String, String, String){
        let clientId = Config.clientId
        let clientSecret = Config.clientSecret
        let todaysDate = Date().description.prefix(10).replacingOccurrences(of: "-", with: "")
        
        return (clientId, clientSecret, todaysDate)
    }
}
