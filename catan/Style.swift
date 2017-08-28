//
//  Style.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 16..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import BonMot

struct Style {
    struct string {
        static let defaultNormal = StringStyle.Part.font(font.defaultNormal)
        static let defaultBold = StringStyle.Part.font(font.defaultBold)
    }
    
    struct font {
        static let defaultBold = UIFont.boldSystemFont(ofSize: 17)
        static let defaultNormal = UIFont.systemFont(ofSize: 17)
        static let smallNormal = UIFont.systemFont(ofSize: 15)
    }
    
    struct dimension {
        static let defaultSpace: CGFloat = 8
        static let largeSpace: CGFloat = 12
        static let smallSpace: CGFloat = 4
        static let xsmallSpace: CGFloat = 2
        static let defaultRadius: CGFloat = 4
        static let defautLineHeight: CGFloat = font.defaultNormal.pointSize + dimension.smallSpace
        static let largeLineHeight: CGFloat = 42
        static let smallLineHeight: CGFloat = font.smallNormal.pointSize + dimension.smallSpace
        static let defaultDividerHeight: CGFloat = 1
        
        struct postCell {
            static let paddingLeft: CGFloat = 16
            static let paddingRight: CGFloat = 16
        }
    }
    
    static func image(asLogo imageView: UIImageView) {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Style.dimension.defaultRadius
        imageView.layer.masksToBounds = true
    }
    
    static func image(asProfile imageView: UIImageView, width: CGFloat) {
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = width/2
        imageView.layer.masksToBounds = true
    }
}
