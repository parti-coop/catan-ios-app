//
//  Post.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 23..
//  Copyright © 2017년 Parti. All rights reserved.
//

import TRON
import SwiftyJSON

class Post: JSONDecodable {
    required init(json: JSON) throws {
        id = json["id"].intValue
        parsedTitle = json["parsed_title"].stringValue
        parsedBody = json["parsed_body"].stringValue
        truncatedParsedBody = json["truncated_parsed_body"].stringValue
        specificDescStripedTags = json["specific_desc_striped_tags"].stringValue
        parti = try Parti(json: json["parti"])
        user = try User(json: json["user"])
        createdAt = json["created_at"].dateTime
        lastStrokedAt = json["last_stroked_at"].dateTime
        isUpvotedByMe = json["is_upvoted_by_me"].boolValue
        upvotesCount = json["upvotes_count"].intValue
        commentsCount = json["comments_count"].intValue
        latestStrokedActivity = json["latest_stroked_activity"].stringValue
        expiredAfter = json["expired_after"].intValue
        
        if let commentsJSON = json["latest_comments"].array {
            latestComments = try commentsJSON.decode()
        } else {
            latestComments = [Comment]()
        }

        survey = try json["survey"].decode()
        wiki = try json["wiki"].decode()
        poll = try json["poll"].decode()
        linkSource = try json["link_source"].decode()
        
        if let fileSourcesJSON = json["file_sources"].array {
            fileSources = try fileSourcesJSON.decode()
        } else {
            fileSources = [FileSource]()
        }
    }
    
    // TODO: 연결된 모델을 만듭니다
    let id: Int
    let parsedTitle: String
    let parsedBody: String
    let truncatedParsedBody: String
    let specificDescStripedTags: String
    let parti: Parti
    let user: User;
    let createdAt: Date?
    let lastStrokedAt: Date?
    var isUpvotedByMe: Bool
    var upvotesCount: Int
    let commentsCount: Int
    var latestComments: [Comment]
    //Comment sticky_comment;
    let linkSource: LinkSource?
    var poll: Poll?
    var survey: Survey?
    var wiki: Wiki?
    //Share share;
    let fileSources: [FileSource];
    let latestStrokedActivity: String
    let expiredAfter: Int
    
    var titleAndBodyAttributedText: NSAttributedString?
    
    func hasNoTitleAndBody() -> Bool {
        return parsedTitle.isBlank() && parsedBody.isBlank()
    }
    
    func hasNoComments() -> Bool {
        return commentsCount <= 0
    }
    
    func fileSourcesOnlyImage() -> [FileSource] {
        return fileSources.filter { (fileSource) -> Bool in
            return fileSource.isImage()
        }
    }
    
    func fileSourcesOnlyDocument() -> [FileSource] {
        return fileSources.filter { (fileSource) -> Bool in
            return !fileSource.isImage()
        }
    }
}
