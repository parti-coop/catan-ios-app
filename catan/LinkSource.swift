//
//  File.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 7..
//  Copyright © 2017년 Parti. All rights reserved.
//

import SwiftyJSON
import TRON

struct LinkSource: JSONDecodable {
    init(json: JSON) throws {
        url = json["url"].stringValue
        title = json["title"].stringValue
        titleOrUrl = json["title_or_url"].stringValue
        body = json["body"].stringValue
        siteName = json["site_name"].stringValue
        imageUrl = json["image_url"].stringValue
        isVideo = json["is_video"].boolValue
        videoAppUrl = json["video_app_url"].stringValue
    }
    
    let url: String
    let title: String
    let titleOrUrl: String
    let body: String
    let siteName: String
    let imageUrl: String
    let isVideo: Bool
    let videoAppUrl: String
}
