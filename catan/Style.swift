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
        static let defaultBold = UIFont.boldSystemFont(ofSize: 14)
        static let defaultNormal = UIFont.systemFont(ofSize: 14)
        static let smallNormal = UIFont.systemFont(ofSize: 12)
    }
    
    struct dimension {
        static let defaultSpace: CGFloat = 6
        static let smallSpace: CGFloat = 3
        static let defaultRadius: CGFloat = 4
        static let defautLineHeight: CGFloat = 24
        static let largeLineHeight: CGFloat = 36
        static let defaultRadious: CGFloat = 5
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
