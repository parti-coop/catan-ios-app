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
    
    private(set) var user: User?
    
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
            UserRequestFactory.fetchMe().perform(with: { [weak self] (user, error) in
                guard let stongSelf = self else { return }
                if let error = error {
                    if error.response?.statusCode == 200 {
                        log.debug("User not found: \(error)")
                        UIAlertController.alertError(message: "회원으로 가입되어 있지 않습니다.")
                        stongSelf.logOut()
                    }
                    
                    completion(nil, error)
                    return
                }
                
                stongSelf.user = user
                completion(stongSelf.user, nil)
            })
        }
    }
}
