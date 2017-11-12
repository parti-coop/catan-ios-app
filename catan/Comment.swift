//
//  Comment.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 29..
//  Copyright © 2017년 Parti. All rights reserved.
//

import SwiftyJSON
import TRON

class Comment: JSONDecodable, HeightCacheKey {
    let heightCacheTimestamp = Date().timeIntervalSince1970
    
    required init(json: JSON) throws {
        id = json["id"].intValue
        body = json["body"].stringValue
        truncatedBody = json["truncated_body"].stringValue
        upvotesCount = json["upvotes_count"].intValue
        user = try User(json: json["user"])
        createdAt = json["created_at"].dateTime
        isMentionable = json["is_mentionable"].boolValue
        isUpvotedByMe = json["is_upvoted_by_me"].boolValue
        isBlinded = json["is_blinded"].boolValue
        choice = json["choice"].stringValue
        isDestroyable = json["is_destroyable"].boolValue
    }
    
    let id: Int
    let body: String
    let truncatedBody: String
    var upvotesCount: Int
    let user: User
    let createdAt: Date?
    let isMentionable: Bool
    var isUpvotedByMe: Bool
    let isBlinded: Bool
    let choice: String
    let isDestroyable: Bool
    
    var bodyAttributedText: NSAttributedString?
    
    weak var post: Post?
    
    // MARK: HeightCacheKey 구현
    
    func keyForHeightCache() -> Int {
        return id
    }
    
    func timestampForHeightCache() -> Double {
        return heightCacheTimestamp
    }
}
