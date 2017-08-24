//
//  Group.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 23..
//  Copyright © 2017년 Parti. All rights reserved.
//

import TRON
import SwiftyJSON

struct Group: JSONDecodable {
    init(json: JSON) throws {
        title = json["title"].stringValue
        slug = json["slug"].stringValue
    }
    
    let title: String
    let slug: String
    
    func isIndie() -> Bool {
        return slug == "indie"
    }
}
