//
//  NetworkRequestRetrier.swift
//  Core
//
//  Created by Sameh Mabrouk on 28/01/2021.
//

import Alamofire

class NetworkRequestRetrier: RequestRetrier {
    
    // [Request url: Number of times retried]
    private var retriedRequests: [String: Int] = [:]
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        guard request.task?.response == nil,
              let url = request.request?.url?.absoluteString
        else {
            removeCachedUrlRequest(url: request.request?.url?.absoluteString)
            completion(.doNotRetry)
            return
        }
        
        guard let retryCount = retriedRequests[url] else {
            retriedRequests[url] = 1
            completion(.retryWithDelay(1.0))
            return
        }
        
        if retryCount <= 3 {
            retriedRequests[url] = retryCount + 1
            completion(.retryWithDelay(1.0))
        } else {
            removeCachedUrlRequest(url: url)
            completion(.doNotRetry)
        }
    }
    
    private func removeCachedUrlRequest(url: String?) {
        guard let url = url else {
            return
        }
        retriedRequests.removeValue(forKey: url)
    }
}
