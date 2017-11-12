//
//  PostTitleAndBodyView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 25..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class PostTitleAndBodyView: UITextView {
    // TODO: 높이를 캐시합니다.
    static let heightCache = HeightCache()
    var forceWidth = CGFloat(0) {
        didSet {
            if post != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
        }
    }
    var collapsibleTopConstraint: CollapsibleTopConstraint?
    
    static let titleFontPointSize = CGFloat(26)
    static let bodyFontPointSize = Style.font.defaultNormal.pointSize
    
    var post: Post? {
        didSet {
            if let post = post, let attributedText = post.titleAndBodyAttributedText {
                self.attributedText = attributedText
            } else{
                self.attributedText = nil
            }
            let height = PostTitleAndBodyView.estimateHeight(post: post, width: forceWidth)
            collapsibleTopConstraint?.adjustConstant(height: height)
            setNeedsLayout()
        }
    }

    static func buildText(_ post: Post) -> NSAttributedString? {
        if post.hasNoTitleAndBody() {
            return nil
        }
        
        let postTitleHtml = buildSmartHtmlString(post.parsedTitle, fontSize: titleFontPointSize, fontWeight: 200) ?? ""
        let postBodyHtmlSource = ( post.truncatedParsedBody.isBlank() ? post.parsedBody : post.truncatedParsedBody )
        let postBodyHtml = buildSmartHtmlString(postBodyHtmlSource, fontSize: bodyFontPointSize) ?? ""
        if let postTitleAndBodyData = "\(postTitleHtml)\(postBodyHtml)".data(using: String.Encoding.unicode, allowLossyConversion: true) {
            if let result = try? NSMutableAttributedString(data: postTitleAndBodyData,
                options: [
                    NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                    "NSOriginalFont": Style.font.defaultNormal,
                    NSFontAttributeName: Style.font.defaultNormal
                ],
                documentAttributes: nil) {
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
    
    static fileprivate func buildSmartHtmlString(_ text: String, fontSize: CGFloat, fontWeight: Int = 400) -> String? {
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
        return "<div style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(fontSize)px; font-weight: \(fontWeight);\">\(parsedText)</div>"
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
        if post == nil || forceWidth <= 0 {
            return super.intrinsicContentSize
        }

        let height = estimateIntrinsicContentHeight()
        return CGSize(width: forceWidth, height: height)
    }

    fileprivate func estimateIntrinsicContentHeight() -> CGFloat {
        let height = PostTitleAndBodyView.estimateHeight(post: self.post, width: forceWidth)
        return height > 0 ? height + 1: CGFloat(0)
    }
    
    static fileprivate func redundantBottomPaddingHeight(post: Post?) -> CGFloat {
        guard let post = post else { return 0 }
        return (post.parsedBody.isBlank() ? (PostTitleAndBodyView.titleFontPointSize) : (PostTitleAndBodyView.bodyFontPointSize))
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        guard let titleAndBodyAttributedText = post?.titleAndBodyAttributedText else { return CGFloat(0) }
        let textHeight = titleAndBodyAttributedText.heightWithConstrainedWidth(width: width)
        let height = textHeight - redundantBottomPaddingHeight(post: post) - 2
        return textHeight > 0 ? height : CGFloat(0)
    }
    
    func anchorCollapsibleTop(_ topAnchor: NSLayoutYAxisAnchor, topConstant: CGFloat) {
        collapsibleTopConstraint = CollapsibleTopConstraint(self, top: topAnchor, topConstant: topConstant)
    }
}
