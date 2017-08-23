//
//  Post.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 23..
//  Copyright © 2017년 Parti. All rights reserved.
//

import TRON
import SwiftyJSON

struct Post: JSONDecodable {
    init(json: JSON) throws {
        id = json["id"].intValue
        parsedTitle = json["parsed_title"].stringValue
        parsedBody = json["parsed_body"].stringValue
        truncatedParsedBody = json["truncated_parsed_body"].stringValue
        specificDescStripedTags = json["specific_desc_striped_tags"].stringValue
        createdAt = json["created_at"].date
        lastStrokedAt = json["last_stroked_at"].date
        isUpVotedByMe = json["is_upvoted_by_me"].boolValue
        upvotesCount = json["upvotes_count"].intValue
        commentsCount = json["comments_count"].intValue
        latestStrokedActivity = json["latest_stroked_activity"].stringValue
        expiredAfter = json["expired_after"].intValue
    }

    
    // TODO: 연결된 모델을 만듭니다
    let id: Int
    let parsedTitle: String
    let parsedBody: String
    let truncatedParsedBody: String
    let specificDescStripedTags: String
    //Parti parti;
    //User user;
    let createdAt: Date?
    let lastStrokedAt: Date?
    let isUpVotedByMe: Bool
    let upvotesCount: Int
    let commentsCount: Int
    //Comment[] latest_comments;
    //Comment sticky_comment;
    //LinkSource link_source;
    //Poll poll;
    //Survey survey;
    //Wiki wiki;
    //Share share;
    //FileSource[] file_sources;
    let latestStrokedActivity: String
    let expiredAfter: Int
}
