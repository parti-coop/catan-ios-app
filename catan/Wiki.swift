//
//  Wiki.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 10. 15..
//  Copyright © 2017년 Parti. All rights reserved.
//

import TRON
import SwiftyJSON

class Wiki: JSONDecodable {
    required init(json: JSON) throws {
        id = json["id"].intValue
        title = json["title"].stringValue
        imageRatio = json["image_ratio"].floatValue
        thumbnailMdUrl = json["thumbnail_md_url"].stringValue
        
        if let authorsJSON = json["authors"].array {
            authors = try authorsJSON.decode()
        } else {
            authors = [User]()
        }
        
        latestActivityBody = json["latest_activity_body"].stringValue
        latestActivityAt = json["latest_activity_at"].dateTime
        url = json["url"].stringValue
    }
    
    let id: Int
    let title: String
    let imageRatio: Float
    let thumbnailMdUrl: String
    let authors: [User]
    let latestActivityBody: String
    let latestActivityAt: Date?
    let url: String
}
