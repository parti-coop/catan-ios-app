//
//  PostTitleAndBodyTextView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 25..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class PostTitleAndBodyTextView: UITextView {
    static let heightCache = HeightCache<NSNumber>()
    static let textsCache = NSCache<NSNumber, NSAttributedString>()

    static let titleFontPointSize = CGFloat(18)
    static let bodyFontPointSize = Style.font.defaultNormal.pointSize
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            if let cached = PostTitleAndBodyTextView.textsCache.object(forKey: NSNumber(value: post.id)) {
                attributedText = cached
            } else {
                attributedText = PostTitleAndBodyTextView.buildText(post)
                trimText()
            
                if let attributedText = attributedText {
                    PostTitleAndBodyTextView.textsCache.setObject(attributedText, forKey: NSNumber(value: post.id))
                }
            }
            setNeedsLayout()
        }
    }
    
    fileprivate func trimText() {
        let allRange = layoutManager.glyphRange(for: textContainer)
        
        var ranges = [NSRange]()
        layoutManager.enumerateLineFragments(forGlyphRange: allRange, using: { (lineRect, usedRect, textContainer, lineRange, stop) in
            ranges.append(lineRange)
        })

        // TODO: 버그가 있는지 체크 필요
        for range in ranges.reversed() {
            if textStorage.attributedSubstring(from: range).string.isBlank() {
                textStorage.deleteCharacters(in: range)
            } else {
                return
            }
        }
    }
    
    static fileprivate func buildText(_ post: Post) -> NSAttributedString? {
        if post.hasNoTitleAndBody() {
            return nil
        }
        
        let postTitleHtml = buildSmartHtmlString(post.parsedTitle, fontSize: titleFontPointSize) ?? ""
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
                paragraphStyle.lineSpacing = 4
                paragraphStyle.paragraphSpacing = 0
                paragraphStyle.paragraphSpacingBefore = 14
                result.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: textRange)
             
                return result
            }
        }
        
        return nil
    }
    
    static fileprivate func buildSmartHtmlString(_ text: String, fontSize: CGFloat) -> String? {
        var parsedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if parsedText.isEmpty { return nil }
        
        // 맨 마지막에 공백 라인을 방지하기 위해 맨 끝에 더미로 빈 라인을 둔다
        let pTag = "</p>"
        let lastToken = String(parsedText.characters.suffix(pTag.characters.count))
        if lastToken == pTag {
            let start = parsedText.index(parsedText.endIndex, offsetBy: -1 * (pTag.characters.count))
            let end = parsedText.endIndex
            parsedText.replaceSubrange(start..<end, with: "<br></p>")
        }
        return "<div style=\"font-size: \(fontSize)px;\">\(parsedText)</div>"
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
        if post == nil || frame.width <= 0 {
            return super.intrinsicContentSize
        }

        var intrinsicContentSize = layoutManager.boundingRect(forGlyphRange: layoutManager.glyphRange(for: textContainer), in: textContainer).size
        intrinsicContentSize.width = UIViewNoIntrinsicMetric
        intrinsicContentSize.height = estimateHeight(width: frame.width)
        return intrinsicContentSize
    }

    fileprivate func estimateHeight(width: CGFloat) -> CGFloat {
        guard let attributedText = attributedText, let post = post else {
            return 0
        }
        
        if let cached = PostTitleAndBodyTextView.heightCache.height(forKey: NSNumber(value: post.id), onWidth: width) {
            return cached
        }
        
        let dummyTextStorage = NSTextStorage(attributedString: attributedText)
        let dummyTextContainer: NSTextContainer = {
            let size = CGSize(width: width, height: .greatestFiniteMagnitude)
            let container = NSTextContainer(size: size)
            container.lineFragmentPadding = 0
            return container
        }()
        let dummyLayoutManager: NSLayoutManager = {
            let layoutManager = NSLayoutManager()
            layoutManager.addTextContainer(dummyTextContainer)
            dummyTextStorage.addLayoutManager(layoutManager)
            return layoutManager
        }()
        
        dummyLayoutManager.glyphRange(for: dummyTextContainer)
        let rect = dummyLayoutManager.usedRect(for: dummyTextContainer)
        var height = rect.size.height
        if height >= 0 {
            height -= redundantBottomPaddingHeight()
        } else {
            height = 0
        }
        
        PostTitleAndBodyTextView.heightCache.setHeight(height, forKey: NSNumber(value: post.id), onWidth: width)
        return height
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        guard let post = post else {
            return 0
        }
        
        if post.hasNoTitleAndBody() {
            return 0
        }
        
        let dummayTextView = PostTitleAndBodyTextView()
        dummayTextView.post = post
        
        return dummayTextView.estimateHeight(width: width)
    }
    
    fileprivate func redundantBottomPaddingHeight() -> CGFloat {
        guard let post = post else { return 0 }
        return (post.parsedBody.isBlank() ? (PostTitleAndBodyTextView.titleFontPointSize) : (PostTitleAndBodyTextView.bodyFontPointSize))
    }
}
