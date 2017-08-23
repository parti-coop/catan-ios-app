//
//  User.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 20..
//  Copyright © 2017년 Parti. All rights reserved.
//

import TRON
import SwiftyJSON

struct User : JSONDecodable {
    init(json: JSON) throws {
        id = json["id"].intValue
        email = json["email"].stringValue
        nickname = json["nickname"].stringValue
        imageUrl = json["image_url"].stringValue
        profileUrl = json["profile_url"].stringValue
    }
    
    let id: Int
    let email: String
    let nickname: String
    let imageUrl: String
    let profileUrl: String
}
