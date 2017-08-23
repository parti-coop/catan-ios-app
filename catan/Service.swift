//
//  Service.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 17..
//  Copyright © 2017년 Parti. All rights reserved.
//

import TRON
import SwiftyJSON
import Alamofire
import Keys

struct Service {
    static let sharedInstance = Service()
    
    fileprivate let tron: TRON = {
        let tron = TRON(baseURL: CatanKeys().serviceBaseUrl, manager: Service.defaultManager())
        return tron
    }()
    
    fileprivate let tronAuthenticated: TRON = {
        let tron = TRON(baseURL: CatanKeys().serviceBaseUrl, manager: Service.authenticatedManager())
        return tron
    }()
    
    class JSONError: JSONDecodable {
        required init(json: JSON) throws {
            print("오류가 발생했습니다")
        }
    }
    
    static func defaultManager() -> SessionManager {
        return buildManager()

    }
    
    static func authenticatedManager() -> SessionManager {
        let manager = buildManager()
        
        let handler = ServiceHandler(
            clientID: AuthToken.clientId,
            baseURL: CatanKeys().serviceBaseUrl,
            userSession: UserSession.sharedInstance
        )

        manager.adapter = handler
        manager.retrier = handler
        
        return manager
    }
    
    fileprivate static func buildManager() -> SessionManager {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "parti.dev": .disableEvaluation
        ]
        
        return Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }

    func request<T : JSONDecodable>(_ path: String, tron: TRON = Service.sharedInstance.tron, method: Alamofire.HTTPMethod = .get, parameters: [String: Any] = [:]) -> APIRequest<T, JSONError> {
        let request: APIRequest<T, JSONError> = tron.request(path)
        request.method = method
        request.parameters = parameters
        return request
    }
    
    func requestAuthenticated<T : JSONDecodable>(_ path: String, method: Alamofire.HTTPMethod = .get, parameters: [String: Any] = [:]) -> APIRequest<T, JSONError> {
        return request(path, tron: tronAuthenticated, method: method, parameters: parameters)
    }
    
    func auth(facebookAccessToken: String, withSuccess successBlock: (() -> Void)?, failure failureBlock: ((Error) -> Void)?) {
        AuthTokenRequestFactory.create(provider: AuthToken.provider.facebook, assertion: facebookAccessToken, secret: nil)
            .resume { (authToken, err) in
                if let err = err, let failureBlock = failureBlock {
                    failureBlock(err)
                    return
                }
                
                if let authToken = authToken {
                    UserSession.sharedInstance.logIn(authToken: authToken)
                    
                    if let successBlock = successBlock {
                        successBlock()
                    }
                }
            }
    }
}

extension APIRequest where Model : Any {
    func resume(_ completion: @escaping (Model?, Error?) -> ()) {
        perform(withSuccess: { (authToken) in
            completion(authToken, nil)
        }) { (err) in
            log.error(err)
            completion(nil, err)
        }
    }
}

struct AuthTokenRequestFactory {
    static func create(provider: AuthToken.provider, assertion: String, secret: String?) -> APIRequest<AuthToken, Service.JSONError> {
        let request: APIRequest<AuthToken, Service.JSONError> = Service.sharedInstance
            .request("/oauth/token", method: .post)
        request.parameters = [
            "client_id": AuthToken.clientId,
            "client_secret": AuthToken.clientSecret,
            "grant_type": AuthToken.grantType.assertion,
            "provider": provider,
            "assertion": assertion
        ]
        request.parameters["secret"] = secret
        return request
    }
    
    static func create(refreshToken: String) -> APIRequest<AuthToken, Service.JSONError> {
        return Service.sharedInstance
            .request("/oauth/token", method: .post, parameters: [
            "client_id": AuthToken.clientId,
            "client_secret": AuthToken.clientSecret,
            "grant_type": AuthToken.grantType.refresh_token,
            "refresh_token": refreshToken
        ])
    }
}

struct UserRequestFactory {
    static func fetchMe() -> APIRequest<User, Service.JSONError> {
        return Service.sharedInstance
            .requestAuthenticated("/api/v1/users/me")
    }
}

struct PostRequestFactory {
    static func fetchPageOnDashBoard(lastPostId: Int? = nil) -> APIRequest<Page<Post>, Service.JSONError> {
        let request: APIRequest<Page<Post>, Service.JSONError> = Service.sharedInstance.requestAuthenticated("/api/v1/posts/dashboard")
        request.parameters["last_id"] = lastPostId
        return request
    }
}

