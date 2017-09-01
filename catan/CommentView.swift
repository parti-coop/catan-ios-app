//
//  CommentView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 30..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class CommentView: UIView {
    static let bodyFontPointSize = Style.font.defaultNormal.pointSize
    let forceWidth: CGFloat
    
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
    
    let upvoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("공감해요", for: .normal)
        button.setTitleColor(.brand_primary, for: .normal)
        return button
    }()

    let commentingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("댓글달기", for: .normal)
        button.setTitleColor(.brand_primary, for: .normal)
        return button
    }()
    
    let createdAtLabel: CatanLabel = {
        let label = CatanLabel()
        label.font = Style.font.smallNormal
        label.textColor = UIColor.app_gray
        return label
    }()
    
    var comment: Comment? {
        didSet {
            guard let comment = comment else { return }
            
            bodyTextView.comment = comment
            userImageView.kf.setImage(with: URL(string: comment.user.imageUrl))
            createdAtLabel.text = buildCreatedAtText(comment)
            setNeedsLayout()
        }
    }
    
    fileprivate func buildCreatedAtText(_ comment: Comment) -> String {
        return comment.createdAt?.timeAgoSinceNowApproximately ?? ""
    }
    
    init(forceWidth: CGFloat) {
        self.forceWidth = forceWidth
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    fileprivate func setupView() {
        addSubview(dividerView)
        addSubview(userImageView)
        addSubview(bodyTextView)
        addSubview(upvoteButton)
        addSubview(commentingButton)
        addSubview(createdAtLabel)

        dividerView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: Style.dimension.defaultSpace, rightConstant: 0, heightConstant: Style.dimension.defaultDividerHeight)
        
        let contentMargin = Style.dimension.defaultSpace
        userImageView.anchor(dividerView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: contentMargin, leftConstant: Style.dimension.commentView.paddingLeft, bottomConstant: 0, rightConstant: 0, widthConstant: Style.dimension.commentView.userImage, heightConstant: Style.dimension.commentView.userImage)
        bodyTextView.anchor(dividerView.bottomAnchor, left: userImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: contentMargin, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: Style.dimension.commentView.paddingRight, widthConstant: 0, heightConstant: 0)
        bodyTextView.forceWidth = CommentView.widthCommentBodyViews(width: forceWidth)
        
        let actionButtonsMargin = CGFloat(0)
        upvoteButton.anchor(bodyTextView.bottomAnchor, left: userImageView.rightAnchor, bottom: nil, right: nil, topConstant: actionButtonsMargin, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: 0, heightConstant: Style.dimension.defautLineHeight)
        commentingButton.anchor(bodyTextView.bottomAnchor, left: upvoteButton.rightAnchor, bottom: nil, right: nil, topConstant: actionButtonsMargin, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: 0, heightConstant: Style.dimension.defautLineHeight)
        createdAtLabel.anchor(bodyTextView.bottomAnchor, left: commentingButton.rightAnchor, bottom: nil, right: nil, topConstant: actionButtonsMargin, leftConstant: Style.dimension.defaultSpace, bottomConstant: 0, rightConstant: 0, heightConstant: Style.dimension.defautLineHeight)
        
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
