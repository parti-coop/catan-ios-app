//
//  Option.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 13..
//  Copyright © 2017년 Parti. All rights reserved.
//

import TRON
import SwiftyJSON

class Option: JSONDecodable {
    required init(json: JSON) throws {
        id = json["id"].intValue
        feedbacksCount = json["feedbacks_count"].intValue
        body = json["body"].stringValue
        percentage = json["percentage"].floatValue
        user = try json["user"].decode()
        isMySelect = json["is_my_select"].boolValue
        isMvp = json["is_mvp"].boolValue
    }
    
    let id: Int
    let feedbacksCount: Int
    let body: String
    let percentage: Float
    let user: User?
    let isMySelect: Bool
    let isMvp: Bool
    
    func toggleFeedback() {
        
    }
}
