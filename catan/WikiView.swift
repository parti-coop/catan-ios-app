//
//  File.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 10. 15..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import BonMot

class WikiView: UIView {
    static let prototype = WikiView()
    
    var forceWidth = CGFloat(0) {
        didSet {
            if post != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
            
            previewView.forceWidth = forceWidth
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
    
    let previewView: WikiPreviewView = {
        let view = WikiPreviewView()
        return view
    }()
    
    var post: Post? {
        didSet {
            
            if let wiki = post?.wiki {
                if let latestActivityBodyLabelText = WikiView.buildLatestActivityBodyLabelText(wiki.latestActivityBody) {
                    latestActivityBodyLabel.attributedText = latestActivityBodyLabelText
                } else {
                    latestActivityBodyLabel.text = "무제"
                }

                previewView.post = post
            }
            
            setNeedsLayout()
            invalidateIntrinsicContentSize()
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
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(latestActivityBodyLabel)
        addSubview(previewView)
        
        latestActivityBodyLabel.anchor(topAnchor, left: leftAnchor, right: rightAnchor,
                                       topConstant: Style.dimension.postCell.wikiPreviewSpace,
                                       leftConstant: 0,
                                       rightConstant: 0)
        previewView.anchor(latestActivityBodyLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,
                           topConstant: Style.dimension.postCell.wikiPreviewSpace,
                           leftConstant: 0, rightConstant: 0)
    }
    
    func visible() -> Bool {
        return WikiView.visible(post)
    }
    
    static func visible(_ post: Post?) -> Bool {
        return post?.wiki != nil
    }
    
    override var intrinsicContentSize: CGSize {
        if post == nil || forceWidth <= 0 {
            return super.intrinsicContentSize
        }
        
        return CGSize(width: forceWidth, height: WikiView.estimateHeight(post: self.post, width: forceWidth))
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        guard let wiki = post?.wiki else { return CGFloat(0) }
        
        var result = CGFloat(Style.dimension.postCell.wikiPreviewSpace)
        
        if let latestActivityBodyLabelText = WikiView.buildLatestActivityBodyLabelText(wiki.latestActivityBody) {
            result += UILabel.estimateHeight(attributedText: latestActivityBodyLabelText, of: WikiView.prototype.latestActivityBodyLabel, width: width)
            result += Style.dimension.postCell.wikiPreviewSpace
        }
        
        result += WikiPreviewView.estimateHeight(post: post, width: width)
        return result
    }
}
