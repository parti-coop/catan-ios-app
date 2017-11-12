//
//  CommentView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 30..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import BonMot

class CommentView: UIView {
    static let bodyFontPointSize = Style.font.defaultNormal.pointSize
    var forceWidth = CGFloat(0) {
        didSet {
            if comment != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
            
            bodyTextView.forceWidth = CommentView.widthCommentBodyViews(width: forceWidth)
        }
    }
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            
            bodyTextView.comment = comment
            userImageView.kf.setImage(with: URL(string: comment.user.imageUrl))
            createdAtLabel.text = buildCreatedAtText(comment)
            upvoteLabel.attributedText = buildUpvoteLabelText(comment)
            setNeedsLayout()
        }
    }
    
    fileprivate func buildCreatedAtText(_ comment: Comment) -> String {
        return comment.createdAt?.timeAgoSinceNowApproximately ?? ""
    }
    
    fileprivate func buildUpvoteLabelText(_ comment: Comment) -> NSAttributedString? {
        if comment.upvotesCount <= 0 { return nil }
        
        let color = (comment.isUpvotedByMe ? UIColor.brand_primary : UIColor.gray)
        let heartImage = #imageLiteral(resourceName: "hearts_filled").withRenderingMode(.alwaysTemplate).tintedImage(color: color)
        
        return NSAttributedString.composed(of: [
            heartImage.styled(with: .baselineOffset(-2)),
            Special.noBreakSpace,
            String(comment.upvotesCount).styled(with: Style.string.defaultSmall, .color(color))
            ])
    }
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .app_light_gray
        return view
    }()
    
    let userImageView: UIImageView = {
        let imageView = UIImageView()
        Style.image(asProfile: imageView, width: Style.dimension.commentView.userImage)
        return imageView
    }()
    
    let bodyTextView: CommentBodyView = {
        let textView = CommentBodyView()
        return textView
    }()
    
    lazy var upvoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("공감해요", for: .normal)
        button.setTitleColor(.brand_primary, for: .normal)
        button.addTarget(self, action: #selector(handleUpvote), for: .touchUpInside)
        return button
    }()
    
    func handleUpvote() {
        guard let comment = comment else { return }
        if comment.isUpvotedByMe {
            UpvoteRequestFactory.destroy(commentId: comment.id).resume { [weak self] (response, error) in
                guard let strongSelf = self, let strongComment = strongSelf.comment else { return }
                if let _ = error {
                    // TODO: 일반 오류인지, 네트워크 오류인지 처리 필요
                    return
                }
                
                strongComment.upvotesCount -= 1
                strongComment.isUpvotedByMe = false
                strongSelf.upvoteLabel.attributedText = strongSelf.buildUpvoteLabelText(strongComment)
            }
        } else {
            UpvoteRequestFactory.create(commentId: comment.id).resume { [weak self] (response, error) in
                guard let strongSelf = self, let strongComment = strongSelf.comment else { return }
                if let _ = error {
                    // TODO: 일반 오류인지, 네트워크 오류인지 처리 필요
                    return
                }
                
                strongComment.upvotesCount += 1
                strongComment.isUpvotedByMe = true
                strongSelf.upvoteLabel.attributedText = strongSelf.buildUpvoteLabelText(strongComment)
            }
        }
    }

    let commentingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("댓글달기", for: .normal)
        button.setTitleColor(.brand_primary, for: .normal)
        button.addTarget(self, action: #selector(handleAddingComment), for: .touchUpInside)
        return button
    }()
    
    func handleAddingComment() {
        print("click comment2")
    }
    
    let createdAtLabel: UILabel = {
        let label = UILabel()
        label.font = Style.font.smallNormal
        label.textColor = UIColor.app_gray
        return label
    }()
    
    let upvoteLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    init(hasDivider: Bool = true) {
        super.init(frame: .zero)
        setupView(hasDivider: hasDivider)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    fileprivate func setupView(hasDivider: Bool) {
        if hasDivider {
            addSubview(dividerView)
        }
        addSubview(userImageView)
        addSubview(bodyTextView)
        addSubview(upvoteButton)
        addSubview(commentingButton)
        addSubview(createdAtLabel)
        addSubview(upvoteLabel)

        if hasDivider {
            dividerView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: Style.dimension.defaultSpace, rightConstant: 0, heightConstant: Style.dimension.defaultDividerHeight)
        }
        
        let contentMargin = Style.dimension.defaultSpace + (hasDivider ? Style.dimension.defaultDividerHeight : 0)
        userImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: contentMargin, leftConstant: Style.dimension.commentView.paddingLeft, bottomConstant: 0, rightConstant: 0, widthConstant: Style.dimension.commentView.userImage, heightConstant: Style.dimension.commentView.userImage)
        bodyTextView.anchor(topAnchor, left: userImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: contentMargin, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: Style.dimension.commentView.paddingRight, widthConstant: 0, heightConstant: 0)
        
        let actionButtonsMargin = CGFloat(0)
        upvoteButton.anchor(bodyTextView.bottomAnchor, left: userImageView.rightAnchor, bottom: nil, right: nil,
                            topConstant: actionButtonsMargin, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: 0,
                            heightConstant: Style.dimension.defautLineHeight)
        commentingButton.anchor(bodyTextView.bottomAnchor, left: upvoteButton.rightAnchor, bottom: nil, right: nil,
                                topConstant: actionButtonsMargin, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: 0,
                                heightConstant: Style.dimension.defautLineHeight)
        createdAtLabel.anchor(bodyTextView.bottomAnchor, left: commentingButton.rightAnchor, bottom: nil, right: nil,
                              topConstant: actionButtonsMargin, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: 0,
                              heightConstant: Style.dimension.defautLineHeight)
        upvoteLabel.anchor(bodyTextView.bottomAnchor, left: createdAtLabel.rightAnchor, bottom: nil, right: nil,
                           topConstant: actionButtonsMargin, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: 0,
                           widthConstant: 0, heightConstant: 0)
        
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: Style.dimension.defaultSpace, right: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        if comment == nil || forceWidth <= 0 {
            return super.intrinsicContentSize
        }
        
        let height = estimateIntrinsicContentHeight()
        return CGSize(width: forceWidth, height: height)
    }
    
    fileprivate func estimateIntrinsicContentHeight() -> CGFloat {
        let height = CommentView.estimateHeight(comment: self.comment, width: forceWidth)
        return height > 0 ? height: CGFloat(0)
    }
    
    static func estimateHeight(comment: Comment?, width: CGFloat) -> CGFloat {
        let bodyTextWidth = widthCommentBodyViews(width: width)
        let bodyTextHeight = CommentBodyView.estimateHeight(comment: comment, width: bodyTextWidth)
        
        return Style.dimension.defaultDividerHeight + Style.dimension.defaultSpace
            + bodyTextHeight + 1
            + Style.dimension.defautLineHeight
            + Style.dimension.defaultSpace
    }
    
    static fileprivate func widthCommentBodyViews(width: CGFloat) -> CGFloat {
        return width
            - Style.dimension.commentView.paddingLeft
            - Style.dimension.commentView.userImage
            - Style.dimension.defaultSpace
            - Style.dimension.commentView.paddingRight
    }
}
