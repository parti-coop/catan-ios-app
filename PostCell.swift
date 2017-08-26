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
    
    static let postTitleTextViewFontPointSize = CGFloat(18)
    static let postBodyTextViewFontPointSize = Style.font.defaultNormal.pointSize
    
    static let prototype = PostCell()
    
    override var datasourceItem: Any? {
        didSet {
            guard let post = datasourceItem as? Post else { return }
            
            partiLogoImageView.kf.setImage(with: URL(string: post.parti.logoUrl))
            partiTitleLabel.text = PostCell.buildPartiTitleText(post)
            
            userImageView.kf.setImage(with: URL(string: post.user.imageUrl))
            userNicknameLabel.text = post.user.nickname
            createdAtLabel.text = PostCell.buildCreatedAtText(post)
            
            postTitleAndBodyTextView.post = post
        }
    }
    
    static fileprivate func buildPartiTitleText(_ post: Post) -> String {
        var partiTitle = post.parti.title
        if !post.parti.group.isIndie() {
            partiTitle += " < \(post.parti.group.title)"
        }
        
        return partiTitle
    }
    
    static fileprivate func buildCreatedAtText(_ post: Post) -> String {
        return post.createdAt?.timeAgoSinceNow ?? ""
    }
    
    let partiLogoImageView: UIImageView = {
        let imageView = UIImageView()
        Style.image(asLogo: imageView)
        return imageView
    }()
    
    let partiTitleLabel: CatanLabel = {
        let label = CatanLabel()
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
    
    let userNicknameLabel: CatanLabel = {
        let label = CatanLabel()
        label.font = Style.font.defaultBold
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let createdAtLabel: CatanLabel = {
        let label = CatanLabel()
        label.font = Style.font.smallNormal
        label.textColor = UIColor.app_gray
        label.backgroundColor = .yellow
        return label
    }()
    
    let postTitleAndBodyTextView: PostTitleAndBodyTextView = {
        let textView = PostTitleAndBodyTextView()
        textView.backgroundColor = .green
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
        partiTitleDividerView.anchor(partiTitleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: Style.dimension.defaultSpace, leftConstant: 0, bottomConstant: 0, rightConstant: 0, heightConstant: Style.dimension.defaultDividerHeight)
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
            return CGFloat(cached)
        }
        
        // partiViews height
        let partiLogoImageViewWidth = Style.dimension.defautLineHeight
        let partiTitleLabelWidth = frame.width
            - Style.dimension.defaultSpace
            - partiLogoImageViewWidth
            - Style.dimension.defaultSpace
            - Style.dimension.defaultSpace
        let partiTitleLabelHeight = CatanLabel.estimateHeight(text: PostCell.buildPartiTitleText(post), width: partiTitleLabelWidth, of: PostCell.prototype.partiTitleLabel)
        let partiViewHeight = Style.dimension.defaultSpace
            + max(partiTitleLabelHeight, Style.dimension.defautLineHeight)
            + Style.dimension.defaultSpace
            + Style.dimension.defaultDividerHeight
        
        // userViews Height
        let userImageViewHeight = Style.dimension.largeLineHeight
        let userImageViewWidth = Style.dimension.largeLineHeight
        let userNickNameLabelWidth = frame.width
            - Style.dimension.defaultSpace
            - userImageViewWidth
            - Style.dimension.defaultSpace
            - Style.dimension.defaultSpace
        let userNickNameLabelHeight = CatanLabel.estimateHeight(text: post.user.nickname, width: userNickNameLabelWidth, of: PostCell.prototype.userNicknameLabel)
        let createdAtLabelHeight = CatanLabel.estimateHeight(text: PostCell.buildCreatedAtText(post), width: userNickNameLabelWidth, of: PostCell.prototype.createdAtLabel)
        let userViewHeight = Style.dimension.defaultSpace
            + max(userImageViewHeight,
                userNickNameLabelHeight
                + Style.dimension.smallSpace
                + createdAtLabelHeight)
        
        // postBasicViews Height
        let postBasicViewsHeight = heightPostTitleAndBodyViews(post, frame: frame)
        
        let result = partiViewHeight + userViewHeight + postBasicViewsHeight
        heightCache.setObject(NSNumber(value: Float(result)), forKey: NSNumber(value: post.id))
        
        return result
    }
    
    static fileprivate func heightPostTitleAndBodyViews(_ post: Post, frame: CGRect) -> CGFloat {
        let postTitleAndBodyTextViewWidth = widthPostTitleAndBodyViews(frame: frame)
        let postTitleAndBodyTextViewHeight = PostTitleAndBodyTextView.estimateHeight(post: post, width: postTitleAndBodyTextViewWidth)
        return (postTitleAndBodyTextViewHeight == 0 ? 0 : Style.dimension.defaultSpace + postTitleAndBodyTextViewHeight)
    }
    
    static fileprivate func widthPostTitleAndBodyViews(frame: CGRect) -> CGFloat {
        return frame.width
            - Style.dimension.defaultSpace
            - Style.dimension.defaultSpace
    }
}
