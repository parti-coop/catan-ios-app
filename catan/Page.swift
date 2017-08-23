//
//  Page.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 23..
//  Copyright © 2017년 Parti. All rights reserved.
//

import TRON
import SwiftyJSON

struct Page<T: JSONDecodable>: JSONDecodable {
    init(json: JSON) throws {
        hasMoreItem = json["has_more_item"].boolValue
        lastStrokedAt = json["last_stroked_at"].date
        
        guard let itemsJSON = json["items"].array else {
            throw NSError(domain: "xyz.parti", code: 1, userInfo: [NSLocalizedDescriptionKey: "서버 응답에 오류가 있습니다"])
        }
        
        self.items = try itemsJSON.decode()
    }
    
    let hasMoreItem: Bool
    let lastStrokedAt: Date?
    let items: [T]
}
