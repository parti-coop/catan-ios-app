//
//  APIHandler.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 20..
//  Copyright © 2017년 Parti. All rights reserved.
//

import Alamofire
import SwiftyJSON

class ServiceHandler: RequestAdapter, RequestRetrier {
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void
    
//    private let sessionManager: SessionManager = {
//        let configuration = URLSessionConfiguration.default
//        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
//        
//        return SessionManager(configuration: configuration)
//    }()
    
    private let lock = NSLock()
    
    private var clientID: String
    private var baseURL: String
    private var userSession: UserSession
    
    private var isRefreshing = false
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    // MARK: - Initialization
    
    public init(clientID: String, baseURL: String, userSession: UserSession) {
        self.clientID = clientID
        self.baseURL = baseURL
        self.userSession = userSession
    }
    
    // MARK: - RequestAdapter
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(baseURL), let accessToken = userSession.accessToken() {
            var urlRequest = urlRequest
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
            return urlRequest
        }
        
        return urlRequest
    }
    
    // MARK: - RequestRetrier
    
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        lock.lock() ; defer { lock.unlock() }
        
        if let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 {
            requestsToRetry.append(completion)
            
            if !isRefreshing, let refreshToken = self.userSession.refreshToken() {
                AuthTokenRequestFactory.create(refreshToken: refreshToken)
                .resume { [weak self] (authToken, error) in
                    guard let strongSelf = self else { return }

                    strongSelf.lock.lock() ; defer { strongSelf.lock.unlock() }

                    var succeeded = true
                    if let error = error {
                        succeeded = false
                        log.error("Refresh authentication fails :", error.localizedDescription)
                    }
                    
                    if let authToken = authToken {
                        strongSelf.userSession.logIn(accessToken: authToken.accessToken, refreshToken: authToken.refreshToken)
                    } else {
                        succeeded = false
                        log.error("Refresh authentication fails. Tokens is empty.")
                    }
                    
                    strongSelf.requestsToRetry.forEach { $0(succeeded, 0.0) }
                    strongSelf.requestsToRetry.removeAll()
                }
            }
        } else {
            completion(false, 0.0)
        }
    }
}

