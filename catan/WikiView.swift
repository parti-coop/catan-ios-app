//
//  File.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 10. 15..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import BonMot

class WikiView: UIStackView {
    // TODO: 높이를 캐시합니다.
    static let heightCache = HeightCache()
    static let prototype = WikiView()
    
    var forceWidth = CGFloat(0) {
        didSet {
            if post != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
        }
    }
    
    let latestActivityBodyLabel: PaddingLabel = {
        let label = PaddingLabel()
        label.backgroundColor = .app_lighter_gray
        label.numberOfLines = 0
        label.leftInset = Style.dimension.defaultSpace
        label.rightInset = Style.dimension.defaultSpace
        label.topInset = Style.dimension.defaultSpace
        label.bottomInset = Style.dimension.defaultSpace
        label.layer.cornerRadius = Style.dimension.defaultRadius
        label.layer.masksToBounds = true
        return label
    }()
    
    var post: Post? {
        didSet {
            removeAllArrangedSubviews()
            
            if let wiki = post?.wiki {
                if let latestActivityBodyLabelText = WikiView.buildLatestActivityBodyLabelText(wiki.latestActivityBody) {
                    addArrangedSubview(latestActivityBodyLabel)
                    latestActivityBodyLabel.attributedText = latestActivityBodyLabelText
                    latestActivityBodyLabel.anchor(topAnchor, left: leftAnchor, right: rightAnchor,
                                                   topConstant: Style.dimension.postCell.wikiPadding)
                }
            }
            
            setNeedsLayout()
        }
    }
    
    static func buildLatestActivityBodyLabelText(_ text: String) -> NSAttributedString? {
        if let textData = text.data(using: String.Encoding.unicode, allowLossyConversion: true) {
            return try? NSMutableAttributedString(data: textData,
                                                    options: [
                                                        NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                        "NSOriginalFont": Style.font.defaultNormal,
                                                        NSFontAttributeName: Style.font.defaultNormal],
                                                    documentAttributes: nil)
        }
        return nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: WikiView.intrinsicContentWidth(width: forceWidth), height: WikiView.estimateHeight(post: post, width: forceWidth))
    }
    
    func visible() -> Bool {
        return WikiView.visible(post)
    }
    
    static func visible(_ post: Post?) -> Bool {
        return post?.wiki != nil
    }
    
    static fileprivate func intrinsicContentWidth(width: CGFloat) -> CGFloat {
        return width
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        guard let wiki = post?.wiki else { return CGFloat(0) }
        
        let topPadding = Style.dimension.postCell.wikiPadding
        
        var result = CGFloat(topPadding)
        
        if let latestActivityBodyLabelText = WikiView.buildLatestActivityBodyLabelText(wiki.latestActivityBody) {
            result += UILabel.estimateHeight(attributedText: latestActivityBodyLabelText, of: WikiView.prototype.latestActivityBodyLabel, width: width)
        }

        return result
    }
}
