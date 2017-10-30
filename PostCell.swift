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
import KRWordWrapLabel

protocol PostRefetchableController: NSObjectProtocol {
    func refetch(post: Post)
}

class PostCell: DatasourceCell, CellRefetchable {
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
            postActionBarView.post = post
            latestCommentsView.post = post
            
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
    
    let partiLogoImageView: UIImageView = {
        let imageView = UIImageView()
        Style.image(asLogo: imageView)
        return imageView
    }()
    
    let partiTitleLabel: KRWordWrapLabel = {
        let label = KRWordWrapLabel()
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
    
    let createdAtLabel: UILabel = {
        let label = UILabel()
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
    
    let postActionBarView: PostActionBarView = {
        let view = PostActionBarView()
        view.backgroundColor = .red
        return view
    }()
    
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
        partiTitleLabel.anchorHeightGreaterThanOrEqualTo(Style.dimension.defautLineHeight)
        
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
        userNicknameLabel.anchorHeightGreaterThanOrEqualTo(Style.dimension.defautLineHeight)
        
        createdAtLabel.anchor(userNicknameLabel.bottomAnchor, left: userImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: Style.dimension.xsmallSpace, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: Style.dimension.postCell.paddingLeft, widthConstant: 0)
        createdAtLabel.anchorHeightGreaterThanOrEqualTo(Style.dimension.smallLineHeight)
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
        postAdditionalView.forceWidth = PostCell.widthPostAdditionalViews(frame: frame)
        postAdditionalView.cellRefetchable = self
    }
    
    fileprivate func setupActionButtons() {
        addSubview(actionDividerView)
        addSubview(postActionBarView)
        
        actionDividerView.anchor(postAdditionalView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,
                                 topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: Style.dimension.defaultDividerHeight)
        postActionBarView.anchor(actionDividerView.topAnchor, left: leftAnchor, right: rightAnchor,
                                 topConstant: 0, leftConstant: 0, rightConstant: 0)
        postActionBarView.forceWidth = PostCell.widthPostActionBarView(frame: frame)
    }
    
    fileprivate func setupLatestCommentsViews() {
        addSubview(latestCommentsView)
        
        latestCommentsView.anchor(postActionBarView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor,
                                  topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        latestCommentsView.forceWidth = PostCell.widthLatestCommentsViews(frame: frame)
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
        let partiTitleLabelHeight = UILabel.estimateHeight(text: PostCell.buildPartiTitleText(post), width: partiTitleLabelWidth, of: PostCell.prototype.partiTitleLabel, greaterThanOrEqualToHeight: Style.dimension.defautLineHeight)
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
        let userNickNameLabelHeight = UILabel.estimateHeight(text: post.user.nickname, width: userNickNameLabelWidth, of: PostCell.prototype.userNicknameLabel, greaterThanOrEqualToHeight: Style.dimension.defautLineHeight)
        let createdAtLabelHeight = UILabel.estimateHeight(text: PostCell.buildCreatedAtText(post), width: userNickNameLabelWidth, of: PostCell.prototype.createdAtLabel, greaterThanOrEqualToHeight: Style.dimension.defautLineHeight)
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
        return PostAdditionalView.estimateHeight(post: post, width: widthPostAdditionalViews(frame: frame))
    }
    
    static fileprivate func widthPostAdditionalViews(frame: CGRect) -> CGFloat {
        return frame.width
    }
    
    static fileprivate func heightActionButtons() -> CGFloat {
        return PostActionBarView.estimateHeight()
    }
    
    static fileprivate func heightLatestCommentsViews(_ post: Post, frame: CGRect) -> CGFloat {
        return LatestCommentsView.estimateHeight(post: post, width: widthLatestCommentsViews(frame: frame))
    }
    
    static fileprivate func widthPostActionBarView(frame: CGRect) -> CGFloat {
        return frame.width
    }
    
    static fileprivate func widthLatestCommentsViews(frame: CGRect) -> CGFloat {
        return frame.width
    }
    
    // Mark: CellReloadable
    
    func refetch() {
        guard let post = datasourceItem as? Post else { return }
        guard let controller = controller as? PostRefetchableController else { return }
        PostCell.heightCache.purgeHeight(forKey: post.id, onWidth: frame.width)
        controller.refetch(post: post)
    }
}
