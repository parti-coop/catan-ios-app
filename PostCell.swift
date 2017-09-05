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
import BonMot

class PostCell: DatasourceCell {
    static let heightCache = HeightCache()
    
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
            
            postTitleAndBodyView.post = post
            postAdditionalView.post = post
            latestCommentsView.post = post
            upvoteLabel.attributedText = buildUpvoteLabelText(post)

            setNeedsLayout()
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
        return post.createdAt?.timeAgoSinceNowApproximately ?? ""
    }
    
    fileprivate func buildUpvoteLabelText(_ post: Post) -> NSAttributedString? {
        if post.upvotesCount <= 0 { return nil }
        
        let color = (post.isUpvotedByMe ? UIColor.brand_primary : UIColor.gray)
        let heartImage = #imageLiteral(resourceName: "hearts_filled").withRenderingMode(.alwaysTemplate).tintedImage(color: color)
        
        return NSAttributedString.composed(of: [
            heartImage.styled(with: .baselineOffset(-2)),
            Special.noBreakSpace,
            String(post.upvotesCount).styled(with: Style.string.defaultSmall, .color(color))
            ])
    }
    
    let partiLogoImageView: UIImageView = {
        let imageView = UIImageView()
        Style.image(asLogo: imageView)
        return imageView
    }()
    
    let partiTitleLabel: CatanLabel = {
        let label = CatanLabel()
        label.font = Style.font.smallNormal
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textColor = .brand_primary
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
        return label
    }()
    
    let postTitleAndBodyView: PostTitleAndBodyView = {
        let textView = PostTitleAndBodyView()
        return textView
    }()
    
    let postAdditionalView: PostAdditionalView = {
        let view = PostAdditionalView()
        return view
    }()
    
    let actionDividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .app_light_gray
        return view
    }()
    
    let upvoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("공감해요", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    let commentingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("댓글달기", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    let upvoteLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let actionButtonsBottomView = UIView()
    
    let latestCommentsView: LatestCommentsView = {
        let view = LatestCommentsView()
        view.backgroundColor = UIColor.app_lighter_gray
        return view
    }()
    
    override func setupViews() {
        separatorLineView.isHidden = false
        separatorLineView.backgroundColor = UIColor.app_light_gray
        backgroundColor = .white

        setupPartiViews()
        setupUserViews()
        setupPostBasicViews()
        setupPostAdditionalViews()
        setupActionButtons()
        setupLatestCommentsViews()
    }
    
    fileprivate func setupPartiViews() {
        addSubview(partiLogoImageView)
        addSubview(partiTitleLabel)
        
        let baseTopAnchor = topAnchor
        
        partiLogoImageView.anchor(baseTopAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: Style.dimension.defaultSpace, leftConstant: Style.dimension.postCell.paddingLeft, bottomConstant: 0, rightConstant: 0, widthConstant: Style.dimension.defautLineHeight, heightConstant: Style.dimension.defautLineHeight)
        
        partiTitleLabel.anchor(baseTopAnchor, left: partiLogoImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: Style.dimension.defaultSpace, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: Style.dimension.postCell.paddingLeft)
        partiTitleLabel.greaterThanOrEqualToHeight(Style.dimension.defautLineHeight)
        
        partiTitleDividerView.backgroundColor = UIColor.app_light_gray
        addSubview(partiTitleDividerView)
        partiTitleDividerView.anchor(partiTitleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: Style.dimension.defaultSpace, leftConstant: 0, bottomConstant: 0, rightConstant: 0, heightConstant: Style.dimension.defaultDividerHeight)
    }
    
    fileprivate func setupUserViews() {
        addSubview(userImageView)
        addSubview(userNicknameLabel)
        addSubview(createdAtLabel)
        
        let baseTopAnchor = partiTitleDividerView.topAnchor
        
        userImageView.anchor(baseTopAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: Style.dimension.defaultSpace, leftConstant: Style.dimension.postCell.paddingLeft, bottomConstant: 0, rightConstant: 0, widthConstant: Style.dimension.largeLineHeight, heightConstant: Style.dimension.largeLineHeight)
        
        userNicknameLabel.anchor(baseTopAnchor, left: userImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: Style.dimension.defaultSpace, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: Style.dimension.postCell.paddingRight, widthConstant: 0)
        userNicknameLabel.greaterThanOrEqualToHeight(Style.dimension.defautLineHeight)
        
        createdAtLabel.anchor(userNicknameLabel.bottomAnchor, left: userImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: Style.dimension.xsmallSpace, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: Style.dimension.postCell.paddingLeft, widthConstant: 0)
        createdAtLabel.greaterThanOrEqualToHeight(Style.dimension.smallLineHeight)
    }
    
    fileprivate func setupPostBasicViews() {
        addSubview(postTitleAndBodyView)
        
        postTitleAndBodyView.anchor(left: leftAnchor, bottom: nil, right: rightAnchor, leftConstant: Style.dimension.postCell.paddingLeft, bottomConstant: 0, rightConstant: Style.dimension.postCell.paddingRight)
        postTitleAndBodyView.forceWidth = PostCell.widthPostTitleAndBodyViews(frame: frame)
        postTitleAndBodyView.anchorCollapsibleTop(createdAtLabel.bottomAnchor, topConstant: Style.dimension.defaultSpace)
    }
    
    fileprivate func setupPostAdditionalViews() {
        addSubview(postAdditionalView)
        
        postAdditionalView.anchor(postTitleAndBodyView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,
                                  topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        postAdditionalView.forceWidth = frame.width
    }
    
    fileprivate func setupActionButtons() {
        addSubview(actionDividerView)
        addSubview(upvoteButton)
        addSubview(commentingButton)
        addSubview(upvoteLabel)
        
        actionDividerView.anchor(postAdditionalView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,
                                 topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: Style.dimension.defaultDividerHeight)
        
        let margin = Style.dimension.defaultSpace
        
        upvoteButton.anchor(actionDividerView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil,
                            topConstant: margin, leftConstant: Style.dimension.postCell.paddingLeft, bottomConstant: 0, rightConstant: 0,
                            heightConstant: Style.dimension.defautLineHeight)
        commentingButton.anchor(actionDividerView.bottomAnchor, left: upvoteButton.rightAnchor, bottom: nil, right: nil,
                                topConstant: margin, leftConstant: Style.dimension.largeSpace, bottomConstant: 0, rightConstant: 0,
                                heightConstant: Style.dimension.defautLineHeight)
        upvoteLabel.anchor(actionDividerView.bottomAnchor, left: commentingButton.rightAnchor, bottom: nil, right: nil,
                           topConstant: margin, leftConstant: Style.dimension.largeSpace, bottomConstant: 0, rightConstant: 0,
                           widthConstant: 0, heightConstant: Style.dimension.defautLineHeight)
    }
    
    fileprivate func setupLatestCommentsViews() {
        addSubview(latestCommentsView)
        
        latestCommentsView.anchor(commentingButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,
                                  topConstant: Style.dimension.defaultSpace, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        latestCommentsView.forceWidth = frame.width
    }
    
    static func height(_ post: Post, frame: CGRect) -> CGFloat {
        if let cached = heightCache.height(forKey: post.id, onWidth: frame.width) {
            return cached
        }
        
        // partiViews height
        let partiLogoImageViewWidth = Style.dimension.defautLineHeight
        let partiTitleLabelWidth = frame.width
            - Style.dimension.postCell.paddingLeft
            - partiLogoImageViewWidth
            - Style.dimension.defaultSpace
            - Style.dimension.postCell.paddingRight
        let partiTitleLabelHeight = CatanLabel.estimateHeight(text: PostCell.buildPartiTitleText(post), width: partiTitleLabelWidth, of: PostCell.prototype.partiTitleLabel, greaterThanOrEqualToHeight: Style.dimension.defautLineHeight)
        let partiViewHeight = Style.dimension.defaultSpace
            + max(partiTitleLabelHeight, Style.dimension.defautLineHeight)
            + Style.dimension.defaultSpace
            + Style.dimension.defaultDividerHeight
        
        // userViews Height
        let userImageViewHeight = Style.dimension.largeLineHeight
        let userImageViewWidth = Style.dimension.largeLineHeight
        let userNickNameLabelWidth = frame.width
            - Style.dimension.postCell.paddingLeft
            - userImageViewWidth
            - Style.dimension.defaultSpace
            - Style.dimension.postCell.paddingRight
        let userNickNameLabelHeight = CatanLabel.estimateHeight(text: post.user.nickname, width: userNickNameLabelWidth, of: PostCell.prototype.userNicknameLabel, greaterThanOrEqualToHeight: Style.dimension.defautLineHeight)
        let createdAtLabelHeight = CatanLabel.estimateHeight(text: PostCell.buildCreatedAtText(post), width: userNickNameLabelWidth, of: PostCell.prototype.createdAtLabel, greaterThanOrEqualToHeight: Style.dimension.defautLineHeight)
        let userViewHeight = Style.dimension.defaultSpace
            + max(userImageViewHeight,
                userNickNameLabelHeight
                + Style.dimension.xsmallSpace
                + createdAtLabelHeight)
        
        let result = partiViewHeight + userViewHeight
            + heightPostTitleAndBodyViews(post, frame: frame) - 3
            + heightPostAdditionalViews(post, frame: frame)
            + heightActionButtons()
            + heightLatestCommentsViews(post, frame: frame)
        
        heightCache.setHeight(result, forKey: post.id, onWidth: frame.width)
        
        return result
    }
    
    static fileprivate func heightPostTitleAndBodyViews(_ post: Post, frame: CGRect) -> CGFloat {
        let postTitleAndBodyViewWidth = widthPostTitleAndBodyViews(frame: frame)
        let postTitleAndBodyViewHeight = PostTitleAndBodyView.estimateHeight(post: post, width: postTitleAndBodyViewWidth)
        return (postTitleAndBodyViewHeight == 0 ? 0 : Style.dimension.defaultSpace + postTitleAndBodyViewHeight)
    }
    
    static fileprivate func widthPostTitleAndBodyViews(frame: CGRect) -> CGFloat {
        return frame.width
            - Style.dimension.postCell.paddingLeft
            - Style.dimension.postCell.paddingRight
    }
    
    static fileprivate func heightPostAdditionalViews(_ post: Post, frame: CGRect) -> CGFloat {
        return PostAdditionalView.estimateHeight(post: post, width: frame.width)
    }
    
    static fileprivate func heightActionButtons() -> CGFloat {
        return Style.dimension.defaultDividerHeight
            + Style.dimension.defaultSpace
            + Style.dimension.defautLineHeight
            + Style.dimension.defaultSpace
    }
    
    static fileprivate func heightLatestCommentsViews(_ post: Post, frame: CGRect) -> CGFloat {
        return LatestCommentsView.estimateHeight(post: post, width: frame.width)
    }
}
