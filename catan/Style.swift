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
        static let defaultBold = UIFont.boldSystemFont(ofSize: 18)
        static let defaultNormal = UIFont.systemFont(ofSize: 18)
        static let smallNormal = UIFont.systemFont(ofSize: 16)
    }
    
    struct dimension {
        static let defaultSpace: CGFloat = 8
        static let largeSpace: CGFloat = 12
        static let smallSpace: CGFloat = 4
        static let defaultRadius: CGFloat = 4
        static let defautLineHeight: CGFloat = 36
        static let largeLineHeight: CGFloat = 50
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
