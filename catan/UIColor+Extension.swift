//
//  Extends.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 15..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import LBTAComponents

extension UIColor {
    static let brand_primary = UIColor(r: 150, g: 111, b: 214)
    static let app_gray = UIColor.gray
    static let app_light_gray = UIColor(r: 210, g: 210, b: 210)
    static let app_lighter_gray = UIColor(r: 232, g: 236, b: 241)
    static let app_blue = UIColor(r: 6, g: 69, b: 174)
    
    static let app_link = brand_primary

    convenience init(netHex:Int) {
        self.init(r: CGFloat((netHex >> 16) & 0xff), g: CGFloat((netHex >> 8) & 0xff), b: CGFloat(netHex & 0xff))
    }
}
