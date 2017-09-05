//
//  PostAdditionalView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 2..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import Kingfisher

class PostAdditionalView: UIStackView {
    // TODO: 높이를 캐시합니다.
    static let heightCache = HeightCache()
    
    var forceWidth = CGFloat(0) {
        didSet {
            if post != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
            documentFileSourcesView.forceWidth = forceWidth
            imageFileSourcesView.forceWidth = forceWidth
        }
    }
    
    let documentFileSourcesView: PostDocumentFileSourcesView = {
        let view = PostDocumentFileSourcesView()
        return view
    }()
    
    let imageFileSourcesView: PostImageFileSourcesView = {
        let view = PostImageFileSourcesView()
        return view
    }()
    
    var post: Post? {
        didSet {
            removeAllArrangedSubview()

            imageFileSourcesView.post = post
            documentFileSourcesView.post = post
            
            setupViews()
            setNeedsLayout()
        }
    }
    
    fileprivate func setupViews() {
        if(imageFileSourcesView.visible()) {
            addArrangedSubview(imageFileSourcesView)
        }
        if(documentFileSourcesView.visible()) {
            addArrangedSubview(documentFileSourcesView)
        }
        
        setupBottomMargin()
    }
    
    fileprivate func removeAllArrangedSubview() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    fileprivate func setupBottomMargin() {
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: estimateBottomMargin(), right: 0)
    }
    
    fileprivate func estimateBottomMargin() -> CGFloat {
        if let _ = arrangedSubviews.last as? PostImageFileSourcesView {
            return PostImageFileSourcesView.estimateBottomMarginIfLastAdditionalView(post: post, defaultMargin: Style.dimension.postCell.postAdditionalViewSpace)
        }
        return CGFloat(arrangedSubviews.count > 0 ? Style.dimension.postCell.postAdditionalViewSpace : 0)
    }
    
    init() {
        super.init(frame: .zero)
        axis = .vertical
        distribution = .equalSpacing
        spacing = Style.dimension.postCell.postAdditionalViewSpace
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        var isPostImageFileSourcesViewLastAdditionalView = false
        var rowCount = 0
        
        let imageFileSourcesHeight = PostImageFileSourcesView.estimateHeight(post: post, width: width)
        if imageFileSourcesHeight > 0 {
            rowCount += 1
            isPostImageFileSourcesViewLastAdditionalView = true
        }
        
        let documentFileSourcesHeight = PostDocumentFileSourcesView.estimateHeight(post: post, width: width)
        if documentFileSourcesHeight > 0 {
            rowCount += 1
            isPostImageFileSourcesViewLastAdditionalView = false
        }
        
        var bottomMargin = CGFloat(0)
        if rowCount > 0 {
            bottomMargin = (isPostImageFileSourcesViewLastAdditionalView
            ? PostImageFileSourcesView.estimateBottomMarginIfLastAdditionalView(post: post, defaultMargin: Style.dimension.postCell.postAdditionalViewSpace)
            : Style.dimension.postCell.postAdditionalViewSpace)
        }
        let rowsSpace = CGFloat(max(0, rowCount - 1)) * Style.dimension.postCell.postAdditionalViewSpace
        
        return imageFileSourcesHeight + documentFileSourcesHeight + bottomMargin + rowsSpace
    }
}
