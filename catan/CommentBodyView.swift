//
//  PostTitleAndBodyView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 25..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import BonMot

class CommentBodyView: UITextView {
    static let heightCache = HeightCache()
    var forceWidth = CGFloat(0) {
        didSet {
            if comment != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
        }
    }
    
    static let bodyFontPointSize = Style.font.defaultNormal.pointSize
    
    var comment: Comment? {
        didSet {
            if let comment = comment, let attributedText = comment.bodyAttributedText {
                self.attributedText = attributedText
            } else{
                self.attributedText = nil
            }
            setNeedsLayout()
        }
    }
    
    static func buildBodyText(_ comment: Comment) -> NSAttributedString? {
        let commentBodyHtml = buildSmartHtmlString(comment.body, fontSize: CommentView.bodyFontPointSize) ?? ""
        if let commentBodyData = commentBodyHtml.data(using: String.Encoding.unicode, allowLossyConversion: true) {
            if let commentBodyText = try? NSMutableAttributedString(data: commentBodyData,
                                                           options: [
                                                            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                            "NSOriginalFont": Style.font.defaultNormal,
                                                            NSFontAttributeName: Style.font.defaultNormal ],
                                                           documentAttributes: nil) {
                
                let result = buildUserNicknameText(comment) + commentBodyText
                let textRange = NSMakeRange(0, result.length)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 2
                paragraphStyle.paragraphSpacing = 0
                paragraphStyle.paragraphSpacingBefore = 14
                result.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: textRange)
                return result.trimText()
            }
        }
        
        return nil
    }
    
    static fileprivate func buildUserNicknameText(_ comment: Comment) -> NSAttributedString {
        return (comment.user.nickname + "  ").styled(
            with: Style.string.defaultBold, .color(.brand_primary))
    }
    
    static fileprivate func buildSmartHtmlString(_ text: String, fontSize: CGFloat) -> String? {
        var parsedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if parsedText.isEmpty { return nil }
        
        // 맨 마지막에 공백 라인을 방지하기 위해 맨 끝에 더미로 빈 라인을 둔다
        let pTag = "</p>"
        let lastToken = String(parsedText.suffix(pTag.count))
        if lastToken == pTag {
            let start = parsedText.index(parsedText.endIndex, offsetBy: -1 * (pTag.count))
            let end = parsedText.endIndex
            parsedText.replaceSubrange(start..<end, with: "<br></p>")
        }
        return "<div style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(fontSize)px;\">\(parsedText)</div>"
    }
    
    public init() {
        super.init(frame: .zero, textContainer: nil)
        backgroundColor = .clear
        isEditable = false
        isScrollEnabled = false
        textContainerInset = .zero
        textContainer.lineFragmentPadding = 0
        linkTextAttributes = [ NSForegroundColorAttributeName: UIColor.app_link, NSUnderlineColorAttributeName: UIColor.clear ]
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        if comment == nil || forceWidth <= 0 {
            return super.intrinsicContentSize
        }

        let height = estimateIntrinsicContentHeight()
        return CGSize(width: forceWidth, height: height)
    }
    
    fileprivate func estimateIntrinsicContentHeight() -> CGFloat {
        let height = CommentBodyView.estimateHeight(comment: self.comment, width: forceWidth)
        return height > 0 ? height + 1: CGFloat(0)
    }
    
    static fileprivate func redundantBottomPaddingHeight(comment: Comment?) -> CGFloat {
        guard let comment = comment, !comment.body.isBlank() else { return 0 }
        return CommentBodyView.bodyFontPointSize
    }
    
    static func estimateHeight(comment: Comment?, width: CGFloat) -> CGFloat {
        guard let comment = comment else { return CGFloat(0) }
        
        if let cached = heightCache.height(for: comment, onWidth: width) {
            return cached
        }
        
        guard let bodyAttributedText = comment.bodyAttributedText else { return CGFloat(0) }
        let textHeight = bodyAttributedText.heightWithConstrainedWidth(width: width)
        let height = max(textHeight - redundantBottomPaddingHeight(comment: comment) + 1, CGFloat(0))
        
        heightCache.setHeight(height, for: comment, onWidth: width)
        return height
    }
}
