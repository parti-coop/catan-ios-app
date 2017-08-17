//
//  AuthToken.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 17..
//  Copyright © 2017년 Parti. All rights reserved.
//

import TRON
import SwiftyJSON
import Keys

struct AuthToken : JSONDecodable {
    static let clientId = CatanKeys().serviceClientId
    static let clientSecret = CatanKeys().serviceClientSecret
    enum grantType {
        case credentials, assertion
    }
    enum provider {
        case facebook
    }
    
    let accessToken: String
    let refreshToken: String
    let expiresIn: Int
    
    init(json: JSON) {
        accessToken = json["access_token"].stringValue
        refreshToken = json["refresh_token"].stringValue
        expiresIn = json["expires_in"].intValue
    }
}

