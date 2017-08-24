//
//  PostCell.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 23..
//  Copyright © 2017년 Parti. All rights reserved.
//

import LBTAComponents
import Kingfisher
import DateToolsSwift

class PostCell: DatasourceCell {
    static let heightCache = NSCache<NSNumber, NSNumber>()
    static let postTitleAndBodyCache = NSCache<NSNumber, NSMutableAttributedString>()
    
    static let DIVIDER_HEIGHT = CGFloat(1)
    static let postBodyTextViewFontPointSize = Style.font.defaultNormal.pointSize
    static let postTitleTextViewFontPointSize = CGFloat(18)
    
    static let prototype = PostCell()
    
    override var datasourceItem: Any? {
        didSet {
            guard let post = datasourceItem as? Post else { return }
            
            partiLogoImageView.kf.setImage(with: URL(string: post.parti.logoUrl))
            partiTitleLabel.text = PostCell.makePartiTitleText(post)
            
            userImageView.kf.setImage(with: URL(string: post.user.imageUrl))
            userNicknameLabel.text = post.user.nickname
            createdAtLabel.text = PostCell.makeCreatedAtText(post)
            
            if let postTitleAndBodyText = PostCell.makePostTitleAndBodyText(post) {
                postTitleAndBodyTextView.attributedText = postTitleAndBodyText
                postTitleAndBodyTextView.isHidden = false
            } else {
                postTitleAndBodyTextView.isHidden = true
            }
            
        }
    }
    
    static fileprivate func makePartiTitleText(_ post: Post) -> String {
        var partiTitle = post.parti.title
        if !post.parti.group.isIndie() {
            partiTitle += " < \(post.parti.group.title)"
        }
        
        return partiTitle
    }
    
    static fileprivate func makeCreatedAtText(_ post: Post) -> String {
        return post.createdAt?.timeAgoSinceNow ?? ""
    }
    
    static fileprivate func makePostTitleAndBodyText(_ post: Post) -> NSMutableAttributedString? {
        if let cached = postTitleAndBodyCache.object(forKey: NSNumber(value: post.id)) {
            return cached
        }
        
        guard let postTitleAndBodyHtml = makePostTitleAndBodyHtml(post) else {
            return nil
        }
        print(postTitleAndBodyHtml)
        
        let styledTitleAndBodyText = NSString(format:"<div style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(postBodyTextViewFontPointSize)\">%@</div>" as NSString, postTitleAndBodyHtml) as String
        if let postTitleAndBodyData = styledTitleAndBodyText.data(using: String.Encoding.unicode, allowLossyConversion: true) {
            let result = try? NSMutableAttributedString(data: postTitleAndBodyData,
                options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                documentAttributes: nil)
            
            if let result = result {
                PostCell.postTitleAndBodyCache.setObject(result, forKey: NSNumber(value: post.id))
            }
            return result
        }
    
        return nil
    }
    
    static fileprivate func makePostTitleAndBodyHtml(_ post: Post) -> String? {
        let postTitleHtml = post.parsedTitle.isEmpty ? "" : NSString(format: "<div style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(postTitleTextViewFontPointSize)\">%@</div>" as NSString, post.parsedTitle) as String
        if post.parsedTitle.isEmpty && post.truncatedParsedBody.isEmpty {
            return nil
        } else {
            return "\(postTitleHtml)\(post.truncatedParsedBody)"
        }
    }
    
    let partiLogoImageView: UIImageView = {
        let imageView = UIImageView()
        Style.image(asLogo: imageView)
        return imageView
    }()
    
    let partiTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Style.font.defaultNormal
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let partiTitleDividerView = UIView()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        Style.image(asProfile: imageView, width: Style.dimension.largeLineHeight)
        return imageView
    }()
    
    let userNicknameLabel: UILabel = {
        let label = UILabel()
        label.font = Style.font.defaultBold
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = Style.font.smallNormal
        label.textColor = UIColor.app_gray
        return label
    }()
    
    let postTitleAndBodyTextView: LBTATextView = {
        let textView = LBTATextView()
        textView.font = Style.font.defaultNormal
        return textView
    }()
    
    override func setupViews() {
        separatorLineView.isHidden = false
        separatorLineView.backgroundColor = UIColor.app_light_gray
        backgroundColor = .white

        setupPartiViews()
        setupUserViews()
        setupPostBasicViews()
    }
    
    fileprivate func setupPartiViews() {
        addSubview(partiLogoImageView)
        addSubview(partiTitleLabel)
        
        let baseTopAnchor = topAnchor
        
        partiLogoImageView.anchor(baseTopAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: Style.dimension.defaultSpace, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: 0, widthConstant: Style.dimension.defautLineHeight, heightConstant: Style.dimension.defautLineHeight)
        
        partiTitleLabel.anchor(baseTopAnchor, left: partiLogoImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: Style.dimension.defaultSpace, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: Style.dimension.defaultSpace)
        
        partiTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: Style.dimension.defautLineHeight).isActive = true
        
        partiTitleDividerView.backgroundColor = UIColor.app_light_gray
        addSubview(partiTitleDividerView)
        partiTitleDividerView.anchor(partiTitleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: Style.dimension.defaultSpace, leftConstant: 0, bottomConstant: 0, rightConstant: 0, heightConstant: PostCell.DIVIDER_HEIGHT)
    }
    
    fileprivate func setupUserViews() {
        addSubview(userImageView)
        addSubview(userNicknameLabel)
        addSubview(createdAtLabel)
        
        let baseTopAnchor = partiTitleDividerView.topAnchor
        
        userImageView.anchor(baseTopAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: Style.dimension.defaultSpace, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: 0, widthConstant: Style.dimension.largeLineHeight, heightConstant: Style.dimension.largeLineHeight)
        
        userNicknameLabel.anchor(baseTopAnchor, left: userImageView.rightAnchor, bottom: nil, right: nil, topConstant: Style.dimension.defaultSpace, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: 0, widthConstant: 0)
        
        createdAtLabel.anchor(userNicknameLabel.bottomAnchor, left: userImageView.rightAnchor, bottom: nil, right: nil, topConstant: Style.dimension.smallSpace, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: 0, widthConstant: 0)
    }
    
    fileprivate func setupPostBasicViews() {
        addSubview(postTitleAndBodyTextView)
        
        postTitleAndBodyTextView.anchor(createdAtLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: Style.dimension.defaultSpace, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: Style.dimension.defaultSpace)
    }
    
    static func height(_ post: Post, frame: CGRect) -> CGFloat {
        if let cached = heightCache.object(forKey: NSNumber(value: post.id)) {
            print("Cached Height : \(post.id)")
            return CGFloat(cached)
        }
        
        // partiViews height
        let partiLogoImageViewWidth = Style.dimension.defautLineHeight
        let partiTitleLabelWidth = frame.width
            - Style.dimension.defaultSpace
            - partiLogoImageViewWidth
            - Style.dimension.defaultSpace
            - Style.dimension.defaultSpace
        let partiTitleLabelHeight = PostCell.estimateLabelHeight(text: PostCell.makePartiTitleText(post), width: partiTitleLabelWidth, font: PostCell.prototype.partiTitleLabel.font)
        let partiViewHeight = Style.dimension.defaultSpace
            + max(partiTitleLabelHeight, Style.dimension.defautLineHeight)
            + Style.dimension.defaultSpace
            + DIVIDER_HEIGHT
        
        // userViews Height
        let userImageViewHeight = Style.dimension.largeLineHeight
        let userImageViewWidth = Style.dimension.largeLineHeight
        let userNickNameLabelWidth = frame.width
            - Style.dimension.defaultSpace
            - userImageViewWidth
            - Style.dimension.defaultSpace
            - Style.dimension.defaultSpace
        let userNickNameLabelHeight = PostCell.estimateLabelHeight(text: post.user.nickname, width: userNickNameLabelWidth, font: PostCell.prototype.userNicknameLabel.font)
        let createdAtLabelHeight = PostCell.estimateLabelHeight(text: PostCell.makeCreatedAtText(post), width: userNickNameLabelWidth, font: PostCell.prototype.createdAtLabel.font)
        let userViewHeight = Style.dimension.defaultSpace
            + max(userImageViewHeight,
                userNickNameLabelHeight
                + Style.dimension.smallSpace
                + createdAtLabelHeight)
        
        // postBasicViews Height
        let postTitleAndBodyTextViewWidth = frame.width
            - Style.dimension.defaultSpace
            - Style.dimension.defaultSpace
        let postTitleAndBodyTextViewHeight = PostCell.estimateHeight(attributedText: PostCell.makePostTitleAndBodyText(post), width: postTitleAndBodyTextViewWidth)
        let removeLastPadding = (post.truncatedParsedBody.isEmpty ? postTitleTextViewFontPointSize : postBodyTextViewFontPointSize) * 2
        let postBasicViewHeight = (postTitleAndBodyTextViewHeight == 0 ?
            0 : Style.dimension.defaultSpace + postTitleAndBodyTextViewHeight - removeLastPadding)
        
        let result = partiViewHeight + userViewHeight + postBasicViewHeight
        heightCache.setObject(NSNumber(value: Float(result)), forKey: NSNumber(value: post.id))
        return result
    }
    
    static private func estimateLabelHeight(text: String, width: CGFloat, font: UIFont) -> CGFloat {
        let size = CGSize(width: width, height: 1000)
        let attributes = [NSFontAttributeName: font]
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        
        return estimatedFrame.height
    }
    
    static private func estimateHeight(attributedText: NSMutableAttributedString?, width: CGFloat) -> CGFloat {
        guard let attributedText = attributedText else { return 0 }
        let size = CGSize(width: width - 2, height: 1000)
        let estimatedFrame = attributedText.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
        return estimatedFrame.height
    }
}
