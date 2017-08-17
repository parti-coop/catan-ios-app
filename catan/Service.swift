//
//  Service.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 17..
//  Copyright © 2017년 Parti. All rights reserved.
//

import TRON
import SwiftyJSON
import KeychainAccess
import Alamofire

struct Service {
    static let sharedInstance = Service()
    
    fileprivate let tron: TRON = {
        let tron = TRON(baseURL: "https://parti.dev", manager: Service.defaultManager())
        return tron
    }()
    
    class JSONError: JSONDecodable {
        required init(json: JSON) throws {
            print("오류가 발생했습니다")
        }
    }
    
    static func defaultManager() -> SessionManager {
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "parti.dev": .disableEvaluation
        ]
        
        let manager = Alamofire.SessionManager(
            configuration: URLSessionConfiguration.default,
            serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
        
        //        let congiuration = Environment.sharedConfiguration
        //        let handler = APIHandler(
        //            clientID: congiuration.get(CatanAPIKeys.clientId)!,
        //            baseURL: congiuration.get(CatanAPIKeys.baseURL)!,
        //            userSession: UserSession.sharedInstance
        //        )
        //
        //        manager.adapter = handler
        //        manager.retrier = handler
        
        return manager

    }
//    
//    func fetchHomeFeed(completion: @escaping (HomeDatasource?, Error?) -> ()) {
//        let request: APIRequest<HomeDatasource, JSONError> = tron.request("/twitter/home")
//        request.perform(withSuccess: { (homeDatasource) in
//            completion(homeDatasource, nil)
//        }) { (err) in
//            completion(nil, err)
//        }
//    }
    func request<T : JSONDecodable>(_ path: String) -> APIRequest<T, JSONError> {
        return tron.request(path)    
    }
    
    func auth(facebookAccessToken: String, withSuccess successBlock: (() -> Void)?, failure failureBlock: ((Error) -> Void)?) {
        AuthTokenRequestFactory.create(
            provider: AuthToken.provider.facebook,
            assertion: facebookAccessToken,
            secret: nil,
            completion: { (authToken, err) in
                if let err = err, let failureBlock = failureBlock {
                    failureBlock(err)
                    return
                }
                
                if let authToken = authToken {
                    self.signIn(authToken: authToken)
                    
                    if let successBlock = successBlock {
                        successBlock()
                    }
                }
            }
        )
    }
    
    
    func signIn(authToken: AuthToken) {
        let keychain = Keychain(service: "xyz.parti.catan")
        keychain["auth_token.access_token"] = authToken.accessToken
        keychain["auth_token.refresh_token"] = authToken.refreshToken
    }
}

extension APIRequest where Model : Any {
    func perform(withCompletion completion: @escaping (Model?, Error?) -> ()) {
        perform(withSuccess: { (authToken) in
            completion(authToken, nil)
        }) { (err) in
            completion(nil, err)
        }
    }
}

struct AuthTokenRequestFactory {
    static func create(provider: AuthToken.provider, assertion: String, secret: String?, completion: @escaping (AuthToken?, Error?) -> ()) {
        let request: APIRequest<AuthToken, Service.JSONError> = Service.sharedInstance.request("/oauth/token")
        request.method = .post
        request.parameters = [
            "client_id": AuthToken.clientId,
            "client_secret": AuthToken.clientSecret,
            "grant_type": AuthToken.grantType.assertion,
            "provider": provider,
            "assertion": assertion
        ]
        request.parameters["secret"] = secret
        request.perform(withCompletion: completion)
    }
}

