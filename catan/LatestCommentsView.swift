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
    var commentViews = [UIView]()
  
    var post: Post? {
        didSet {
            for commentView in commentViews {
                commentView.removeFromSuperview()
            }
            commentViews.removeAll()
            
            if let post = post {
                setupCommentViews(post: post)
            }
            invalidateIntrinsicContentSize()
        }
    }
    
    private func setupCommentViews(post: Post) {
        var currentTopAnchor = topAnchor
        for comment in post.latestComments {
            let commentView = UIView()
            commentView.backgroundColor = [ UIColor.red, UIColor.yellow, UIColor.blue, UIColor.green ][comment.id % 4]
            addSubview(commentView)
            
            commentView.anchor(currentTopAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, heightConstant: 100)
            
            currentTopAnchor = commentView.bottomAnchor
            commentViews.append(commentView)
        }
    }
    
    override var intrinsicContentSize: CGSize {
        guard let post = post, !post.hasNoComments() else { return CGSize.zero }
        return CGSize(width: frame.width, height: CGFloat(100 * post.latestComments.count))
    }
    
    public init() {
        super.init(frame: .zero)
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func estimateHeight(width: CGFloat) -> CGFloat {
        guard let post = post else { return 0 }
        if post.hasNoComments() { return 0 }
        
        return intrinsicContentSize.height
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        let dummyView = LatestCommentsView(frame: CGRect(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        dummyView.post = post
        return dummyView.intrinsicContentSize.height
    }
}
