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
        static let largeThin = StringStyle.Part.font(font.largeThin)
        static let defaultNormal = StringStyle.Part.font(font.defaultNormal)
        static let defaultBold = StringStyle.Part.font(font.defaultBold)
        static let defaultSmall = StringStyle.Part.font(font.smallNormal)
    }
    
    struct font {
        static let largeThin = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.thin)
        static let defaultThin = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.thin)
        static let smallThin = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.thin)
        static let defaultBold = UIFont.boldSystemFont(ofSize: 17)
        static let defaultNormal = UIFont.systemFont(ofSize: 17)
        static let smallNormal = UIFont.systemFont(ofSize: 15)
        static let tinyNormal = UIFont.systemFont(ofSize: 13)
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
        static let defaultBorderWidth: CGFloat = 1
        
        struct postCell {
            static let paddingLeft: CGFloat = 16
            static let paddingRight: CGFloat = 16
            static let imageFileSourceSpace: CGFloat = dimension.smallSpace
            static let documentFileSourceSpace: CGFloat = dimension.smallSpace
            static let firstImageFileSourceMaxHeight: CGFloat = 1000
            static let remainImageFileSourceHeight: CGFloat = 150
            static let postAdditionalViewSpace = dimension.defaultSpace
            static let downloadButtonSize: CGFloat = 50
            static let downloadProgressRingSize: CGFloat = 22
            static let linkSourceImageSize: CGFloat = 150
            static let linkSourceDesciptionPadding: CGFloat = 16
            static let pollPadding: CGFloat = 16
            static let pollVoteButtonWidth: CGFloat = 100
            static let pollVoteButtonHeight: CGFloat = 60
            static let postVoteUserImageSize: CGFloat = 14
            static let optionCheckSize: CGFloat = font.defaultNormal.pointSize
            static let optionBarHeight: CGFloat = dimension.defautLineHeight
            static let optionMetaHeight: CGFloat = dimension.largeLineHeight
            static let surveyPadding: CGFloat = Style.dimension.defaultSpace
            static let wikiPreviewPadding: CGFloat = Style.dimension.defaultSpace
            static let wikiPreviewSpace: CGFloat = Style.dimension.defaultSpace
            static let wikiPreviewImageMaxHeight: CGFloat = 400
        }
        struct commentView {
            static let paddingLeft: CGFloat = 16
            static let paddingRight: CGFloat = 16
            static let userImage: CGFloat = 28
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
