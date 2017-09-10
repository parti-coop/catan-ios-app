//
//  Survey.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 11..
//  Copyright © 2017년 Parti. All rights reserved.
//

import TRON
import SwiftyJSON

class Survey: JSONDecodable {
    required init(json: JSON) throws {
        id = json["id"].intValue
        feedbacksCount = json["feedbacks_count"].intValue
        feedbackUsersCount = json["feedback_users_count"].intValue
        expiresAt = json["expires_at"].dateTime
        multipleSelect = json["multiple_select"].boolValue
        isOpen = json["is_open"].boolValue
        isFeedbackedByMe = json["is_feedbacked_by_me"].boolValue
        remainTimeHuman = json["remain_time_human"].stringValue
    }
    
    let id: Int
    let feedbacksCount: Int
    let feedbackUsersCount: Int
    let expiresAt: Date?
    let multipleSelect: Bool
    //let options
    let isOpen: Bool
    let isFeedbackedByMe: Bool
    let remainTimeHuman: String
}
