//
//  LatestCommentsView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 26..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class LatestCommentsView: UIView {
    static let heightCache = HeightCache()
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
    
    private func setupCommentViews(post: Post?) {
        for commentView in commentViews {
            commentView.removeFromSuperview()
        }
        commentViews.removeAll()
        
        guard let post = post else { return }
        
        var currentTopAnchor = topAnchor
        for comment in post.latestComments {
            let commentView = CommentView()
            commentView.forceWidth = self.forceWidth
            addSubview(commentView)
            commentView.anchor(currentTopAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
            commentView.comment = comment
            
            currentTopAnchor = commentView.bottomAnchor
            commentViews.append(commentView)
        }
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
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func estimateIntrinsicContentHeight(width: CGFloat) -> CGFloat {
        return LatestCommentsView.estimateHeight(post: post, width: width)
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        guard let post = post, !post.hasNoComments() else { return 0 }
        if let cached = heightCache.height(forKey: post.id, onWidth: width) {
            return cached
        }
        
        var height = CGFloat(0)
        for comment in post.latestComments {
            height += CommentView.estimateHeight(comment: comment, width: width)
        }
        
        heightCache.setHeight(height, forKey: post.id, onWidth: width)
        return height
    }
}
