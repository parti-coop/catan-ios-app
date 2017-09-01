//
//  Date+Extension.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 2..
//  Copyright © 2017년 Parti. All rights reserved.
//

import Foundation


public extension Date {
    public var timeAgoSinceNowApproximately: String {
        if daysEarlier(than: Date()) > 3 {
            return format(with: .short)
        }
        return self.timeAgo(since:Date())
    }
}
