//
//  LatestCommentsView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 26..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

protocol LatestCommentsViewDelegate: class {
    func didTapMoreComments(post: Post)
}

class LatestCommentsView: UIView {
    static let prototype = LatestCommentsView()
    static let heightCache = HeightCache()
    weak var delegate: LatestCommentsViewDelegate?
    var commentViews = [CommentView]()
    var forceWidth = CGFloat(0) {
        didSet {
            if post != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
        }
    }

    var post: Post? {
        didSet {
            setupCommentViews(post: post)
            setNeedsLayout()
        }
    }
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .app_light_gray
        return view
    }()
    
    let moreButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitleColor(UIColor.app_gray, for: .normal)
        button.titleLabel?.font =  Style.font.smallNormal
        button.addTarget(self, action: #selector(handleMoreComments), for: .touchUpInside)
        return button
    }()
    
    func handleMoreComments() {
        guard let post = post else { return }
        delegate?.didTapMoreComments(post: post)
    }
    
    private func setupCommentViews(post: Post?) {
        for commentView in commentViews {
            commentView.removeFromSuperview()
        }
        commentViews.removeAll()
        
        guard let post = post else { return }
        
        var currentTopAnchor = topAnchor
        if post.latestComments().count < post.commentsCount {
            moreButton.setTitle(LatestCommentsView.buildMoreText(post: post), for: .normal)
            moreButton.isHidden = false
            currentTopAnchor = moreButton.bottomAnchor
        } else {
            moreButton.isHidden = true
        }
        
        
        for (index, comment) in post.latestComments().enumerated() {
            let commentView = CommentView(hasDivider: index != 0)
            commentView.forceWidth = self.forceWidth
            commentView.delegate = delegate as? CommentViewDelegate
            
            addSubview(commentView)
            commentView.anchor(currentTopAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
            commentView.comment = comment
            
            currentTopAnchor = commentView.bottomAnchor
            commentViews.append(commentView)
        }
    }
    
    static func buildMoreText(post: Post) -> String {
        return "이전 댓글 보기 \(post.commentsCount)개"
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        if post == nil || forceWidth <= 0 {
            return super.intrinsicContentSize
        }
        
        if post!.hasNoComments() {
            return CGSize.zero
        }
        
        let height = estimateIntrinsicContentHeight(width: forceWidth)
        return CGSize(width: forceWidth, height: height)
    }
    
    public init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    func setupViews() {
        addSubview(dividerView)
        addSubview(moreButton)
        
        dividerView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: Style.dimension.defaultDividerHeight)
        moreButton.anchor(dividerView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: Style.dimension.defaultSpace, leftConstant: Style.dimension.commentView.paddingLeft, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: Style.dimension.defautLineHeight)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func estimateIntrinsicContentHeight(width: CGFloat) -> CGFloat {
        return LatestCommentsView.estimateHeight(post: post, width: width)
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        guard let post = post, !post.hasNoComments() else { return 0 }
        if let cached = heightCache.height(for: post, onWidth: width) {
            return cached
        }
        
        var height = CGFloat(0)
        
        height += Style.dimension.defaultDividerHeight
        
        if post.latestComments().count < post.commentsCount {
            height += Style.dimension.defaultSpace
            height += Style.dimension.defautLineHeight
        }
        for comment in post.latestComments() {
            height += CommentView.estimateHeight(comment: comment, width: width)
        }
        
        heightCache.setHeight(height, for: post, onWidth: width)
        return height
    }
    
}
