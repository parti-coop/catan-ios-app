//
//  UserSession.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 20..
//  Copyright © 2017년 Parti. All rights reserved.
//

import Foundation
import KeychainAccess

class UserSession {
    static let sharedInstance = UserSession()
    private let keychain = Keychain(service: "xyz.parti.catan")
    
    var user: User?
    
    func logIn(authToken: AuthToken) {
        logIn(accessToken: authToken.accessToken, refreshToken: authToken.refreshToken)
    }
    
    func logIn(accessToken: String, refreshToken: String) {
        keychain["auth_token.access_token"] = accessToken
        keychain["auth_token.refresh_token"] = refreshToken
    }
    
    func logOut() {
        keychain["auth_token.access_token"] = nil
        keychain["auth_token.refresh_token"] = nil
    }
    
    func accessToken() -> String? {
        do {
            return try keychain.get("auth_token.access_token")
        } catch let err {
            log.error("Fail to Keychange :", err.localizedDescription)
            return nil
        }
    }
    
    func refreshToken() -> String? {
        do {
            return try keychain.get("auth_token.refresh_token")
        } catch let err {
            log.error("Fail to Keychange :", err.localizedDescription)
            return nil
        }
    }
    
    func isLogin() -> Bool {
        return accessToken() != nil
    }
    
    func cacheUser(completion: @escaping (User?, Error?) -> ()) {
        if isLogin() {
            UserRequestFactory.fetchMe().resume { (user, error) in
                if let error = error {
                    // TODO 로그인한 사용자가 없는지, 네트워크 오류인지 처리 필요
                    log.debug("User not found: \(error)")
                    //logOut()
                    completion(nil, error)
                    return
                }
                
                self.user = user
                completion(self.user, nil)
            }
        }
    }
}
