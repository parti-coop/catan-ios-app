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

// TODO PostCellDelegate --> PostViewDelegate
protocol PostViewDelegate: class {
    func refetch(post: Post)
    func didTapDetail(post: Post)
}

class PostView: UIView, CellRefetchable {
    static let heightCache = HeightCache()
    
    static let postTitleTextViewFontPointSize = CGFloat(18)
    static let postBodyTextViewFontPointSize = Style.font.defaultNormal.pointSize
    
    static let prototype = PostView()
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            
            partiLogoImageView.kf.setImage(with: URL(string: post.parti.logoUrl))
            partiTitleLabel.text = PostView.buildPartiTitleText(post)
            
            userImageView.kf.setImage(with: URL(string: post.user.imageUrl))
            userNicknameLabel.text = post.user.nickname
            createdAtButton.setTitle(PostView.buildCreatedAtText(post), for: .normal)
            
            postTitleAndBodyView.post = post
            postAdditionalView.post = post
            postActionBarView.post = post
            latestCommentsView.post = post
            
            setNeedsLayout()
        }
    }
    
    weak var delegate: PostViewDelegate? {
        didSet {
            postActionBarView.delegate = delegate as? PostActionBarDelegate
            latestCommentsView.delegate = delegate as? LatestCommentsViewDelegate
        }
    }
    
    static func buildPartiTitleText(_ post: Post) -> String {
        var partiTitle = post.parti.title
        if !post.parti.group.isIndie() {
            partiTitle += " < \(post.parti.group.title)"
        }
        return partiTitle
    }
    
    static fileprivate func buildCreatedAtText(_ post: Post) -> String {
        return post.createdAt?.timeAgoSinceNowApproximately ?? ""
    }
    
    let partiLogoImageView: UIImageView = {
        let imageView = UIImageView()
        Style.image(asLogo: imageView)
        return imageView
    }()
    
    let partiTitleLabel: UILabel = {
        let label = UILabel()
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
    
    let userNicknameLabel: UILabel = {
        let label = UILabel()
        label.font = Style.font.defaultBold
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var createdAtButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(.app_gray, for: .normal)
        button.titleLabel?.font = Style.font.smallNormal
        button.addTarget(self, action: #selector(handleDetail), for: .touchUpInside)
        return button
    }()
    
    func handleDetail() {
        guard let delegate = delegate, let post = post else { return }
        delegate.didTapDetail(post: post)
    }
    
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
    
    let postActionBarView: PostActionBarView = {
        let view = PostActionBarView()
        return view
    }()
    
    let latestCommentsView: LatestCommentsView = {
        let view = LatestCommentsView()
        view.backgroundColor = UIColor.app_lighter_gray
        return view
    }()
    
    func setupViews(width: CGFloat) {
        backgroundColor = .white
        
        setupPartiViews()
        setupUserViews()
        setupPostBasicViews(width: width)
        setupPostAdditionalViews(width: width)
        setupActionButtons(width: width)
        setupLatestCommentsViews(width: width)
    }
    
    fileprivate func setupPartiViews() {
        addSubview(partiLogoImageView)
        addSubview(partiTitleLabel)
        
        let baseTopAnchor = topAnchor
        
        partiLogoImageView.anchor(baseTopAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: Style.dimension.defaultSpace, leftConstant: Style.dimension.postCell.paddingLeft, bottomConstant: 0, rightConstant: 0, widthConstant: Style.dimension.defautLineHeight, heightConstant: Style.dimension.defautLineHeight)
        
        partiTitleLabel.anchor(baseTopAnchor, left: partiLogoImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: Style.dimension.defaultSpace, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: Style.dimension.postCell.paddingLeft)
        partiTitleLabel.anchorHeightGreaterThanOrEqualTo(Style.dimension.defautLineHeight)
        
        partiTitleDividerView.backgroundColor = UIColor.app_light_gray
        addSubview(partiTitleDividerView)
        partiTitleDividerView.anchor(partiTitleLabel.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: Style.dimension.defaultSpace, leftConstant: 0, bottomConstant: 0, rightConstant: 0, heightConstant: Style.dimension.defaultDividerHeight)
    }
    
    fileprivate func setupUserViews() {
        addSubview(userImageView)
        addSubview(userNicknameLabel)
        addSubview(createdAtButton)
        
        let baseTopAnchor = partiTitleDividerView.topAnchor
        
        userImageView.anchor(baseTopAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: Style.dimension.defaultSpace, leftConstant: Style.dimension.postCell.paddingLeft, bottomConstant: 0, rightConstant: 0, widthConstant: Style.dimension.largeLineHeight, heightConstant: Style.dimension.largeLineHeight)
        
        userNicknameLabel.anchor(baseTopAnchor, left: userImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: Style.dimension.defaultSpace, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: Style.dimension.postCell.paddingRight, widthConstant: 0)
        userNicknameLabel.anchorHeightGreaterThanOrEqualTo(Style.dimension.defautLineHeight)
        
        createdAtButton.anchor(userNicknameLabel.bottomAnchor, left: userImageView.rightAnchor, bottom: nil, topConstant: Style.dimension.xsmallSpace, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, widthConstant: 0, heightConstant: Style.dimension.defautLineHeight)
    }
    
    fileprivate func setupPostBasicViews(width: CGFloat) {
        addSubview(postTitleAndBodyView)
        
        postTitleAndBodyView.anchor(left: leftAnchor, bottom: nil, right: rightAnchor, leftConstant: Style.dimension.postCell.paddingLeft, bottomConstant: 0, rightConstant: Style.dimension.postCell.paddingRight)
        postTitleAndBodyView.forceWidth = PostView.widthPostTitleAndBodyViews(width: width)
        postTitleAndBodyView.anchorCollapsibleTop(createdAtButton.bottomAnchor, topConstant: Style.dimension.defaultSpace)
    }
    
    fileprivate func setupPostAdditionalViews(width: CGFloat) {
        addSubview(postAdditionalView)
        
        postAdditionalView.anchor(postTitleAndBodyView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,
                                  topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        postAdditionalView.forceWidth = PostView.widthPostAdditionalViews(width: width)
        postAdditionalView.cellRefetchable = self
    }
    
    fileprivate func setupActionButtons(width: CGFloat) {
        addSubview(actionDividerView)
        addSubview(postActionBarView)
        
        actionDividerView.anchor(postAdditionalView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,
                                 topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: Style.dimension.defaultDividerHeight)
        postActionBarView.anchor(actionDividerView.topAnchor, left: leftAnchor, right: rightAnchor,
                                 topConstant: 0, leftConstant: 0, rightConstant: 0)
        postActionBarView.forceWidth = PostView.widthPostActionBarView(width: width)
    }
    
    fileprivate func setupLatestCommentsViews(width: CGFloat) {
        addSubview(latestCommentsView)
        
        latestCommentsView.anchor(postActionBarView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,
                                  topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        latestCommentsView.forceWidth = PostView.widthLatestCommentsViews(width: width)
    }
    
    static func height(_ post: Post, width: CGFloat) -> CGFloat {
        if let cached = heightCache.height(for: post, onWidth: width) {
            return cached
        }
        
        // partiViews height
        let partiLogoImageViewWidth = Style.dimension.defautLineHeight
        let partiTitleLabelWidth = width
            - Style.dimension.postCell.paddingLeft
            - partiLogoImageViewWidth
            - Style.dimension.defaultSpace
            - Style.dimension.postCell.paddingRight
        let partiTitle = PostView.buildPartiTitleText(post)
        let partiTitleLabelHeight = UILabel.estimateHeight(text: partiTitle, width: partiTitleLabelWidth, of: PostView.prototype.partiTitleLabel, greaterThanOrEqualToHeight: Style.dimension.defautLineHeight)
        let partiViewHeight = Style.dimension.defaultSpace
            + max(partiTitleLabelHeight, Style.dimension.defautLineHeight)
            + Style.dimension.defaultSpace
            + Style.dimension.defaultDividerHeight
        
        // userViews Height
        let userImageViewHeight = Style.dimension.largeLineHeight
        let userImageViewWidth = Style.dimension.largeLineHeight
        let userNickNameLabelWidth = width
            - Style.dimension.postCell.paddingLeft
            - userImageViewWidth
            - Style.dimension.defaultSpace
            - Style.dimension.postCell.paddingRight
        let userNickNameLabelHeight = UILabel.estimateHeight(text: post.user.nickname, width: userNickNameLabelWidth, of: PostView.prototype.userNicknameLabel, greaterThanOrEqualToHeight: Style.dimension.defautLineHeight)
        let createdAtLabelHeight = Style.dimension.defautLineHeight
        let userViewHeight = Style.dimension.defaultSpace
            + max(userImageViewHeight,
                  userNickNameLabelHeight
                    + Style.dimension.xsmallSpace
                    + createdAtLabelHeight)
        
        let result = partiViewHeight + userViewHeight
            + heightPostTitleAndBodyViews(post, width: width) - 3
            + heightPostAdditionalViews(post, width: width)
            + heightActionButtons(post)
            + heightLatestCommentsViews(post, width: width)
        
        heightCache.setHeight(result, for: post, onWidth: width)
        
        return result
    }
    
    static fileprivate func heightPostTitleAndBodyViews(_ post: Post, width: CGFloat) -> CGFloat {
        let postTitleAndBodyViewWidth = widthPostTitleAndBodyViews(width: width)
        let postTitleAndBodyViewHeight = PostTitleAndBodyView.estimateHeight(post: post, width: postTitleAndBodyViewWidth)
        return (postTitleAndBodyViewHeight == 0 ? 0 : Style.dimension.defaultSpace + postTitleAndBodyViewHeight)
    }
    
    static fileprivate func widthPostTitleAndBodyViews(width: CGFloat) -> CGFloat {
        return width
            - Style.dimension.postCell.paddingLeft
            - Style.dimension.postCell.paddingRight
    }
    
    static fileprivate func heightPostAdditionalViews(_ post: Post, width: CGFloat) -> CGFloat {
        return PostAdditionalView.estimateHeight(post: post, width: widthPostAdditionalViews(width: width))
    }
    
    static fileprivate func widthPostAdditionalViews(width: CGFloat) -> CGFloat {
        return width
    }
    
    static fileprivate func heightActionButtons(_ post: Post) -> CGFloat {
        return PostActionBarView.estimateHeight(post: post)
    }
    
    static fileprivate func heightLatestCommentsViews(_ post: Post, width: CGFloat) -> CGFloat {
        return LatestCommentsView.estimateHeight(post: post, width: widthLatestCommentsViews(width: width))
    }
    
    static fileprivate func widthPostActionBarView(width: CGFloat) -> CGFloat {
        return width
    }
    
    static fileprivate func widthLatestCommentsViews(width: CGFloat) -> CGFloat {
        return width
    }
    
    // Mark: CellRefetchable
    
    func refetch() {
        guard let post = post, let delegate = delegate else { return }
        delegate.refetch(post: post)
    }
}

