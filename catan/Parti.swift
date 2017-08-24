//
//  Parti.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 23..
//  Copyright © 2017년 Parti. All rights reserved.
//

import TRON
import SwiftyJSON

struct Parti: JSONDecodable {
    init(json: JSON) throws {
        id = json["id"].intValue
        title = json["title"].stringValue
        body = json["body"].stringValue
        slug = json["slug"].stringValue
        logoUrl = json["logo_url"].stringValue
        group = try Group(json: json["group"])
        updatedAt = json["updated_at"].dateTime
        latestMembersCount = json["latest_members_count"].intValue
        latestPostsCount = json["latest_posts_count"].intValue
        membersCount = json["members_count"].intValue
        postsCount = json["posts_count"].intValue
        isMember = json["is_member"].boolValue
        isMadeBy = json["is_made_by"].boolValue
        isMadeByTargetUser = json["is_made_by_target_user"].boolValue
        isPostable = json["is_postable"].boolValue
    }
    
    let id: Int
    let title: String
    let body: String
    let slug: String
    let logoUrl: String
    let group: Group
    let updatedAt: Date?
    let latestMembersCount: Int
    let latestPostsCount: Int
    let membersCount: Int
    let postsCount: Int
    let isMember: Bool
    let isMadeBy: Bool
    let isMadeByTargetUser: Bool
    let isPostable: Bool
}
