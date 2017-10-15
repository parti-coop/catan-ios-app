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
    
    weak var cellRefetchable: CellRefetchable? {
        didSet {
            surveyView.cellRefetchable = cellRefetchable
        }
    }
    
    var forceWidth = CGFloat(0) {
        didSet {
            if post != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
            let subviewWidth = PostAdditionalView.estimateSubviewWidth(width: forceWidth)
            surveyView.forceWidth = subviewWidth
            pollView.forceWidth = subviewWidth
            linkSourceView.forceWidth = subviewWidth
            documentFileSourcesView.forceWidth = subviewWidth
            imageFileSourcesView.forceWidth = forceWidth
        }
    }
    
    let linkSourceView: LinkSourceView = {
        let view = LinkSourceView()
        return view
    }()
    
    let surveyView: SurveyView = {
        let view = SurveyView()
        return view
    }()
    
    let pollView: PollView = {
        let view = PollView()
        return view
    }()
    
    let documentFileSourcesView: PostDocumentFileSourcesView = {
        let view = PostDocumentFileSourcesView()
        return view
    }()
    
    let imageFileSourcesView: PostImageFileSourcesView = {
        let view = PostImageFileSourcesView()
        return view
    }()
    
    let wikiView: WikiView = {
        let view = WikiView()
        return view
    }()
    
    var post: Post? {
        didSet {
            removeAllArrangedSubviews()

            surveyView.post = post
            pollView.post = post
            linkSourceView.post = post
            imageFileSourcesView.post = post
            documentFileSourcesView.post = post
            wikiView.post = post
            
            setupViews()
            setNeedsLayout()
        }
    }
    
    fileprivate func setupViews() {
        if(linkSourceView.visible()) {
            addArrangedSubview(linkSourceView)
            linkSourceView.anchor(left: leftAnchor, right: rightAnchor,
                                  leftConstant: Style.dimension.postCell.paddingLeft, rightConstant: Style.dimension.postCell.paddingRight)
        }
        
        if(surveyView.visible()) {
            addArrangedSubview(surveyView)
            surveyView.anchor(left: leftAnchor, right: rightAnchor,
                            leftConstant: Style.dimension.postCell.paddingLeft, rightConstant: Style.dimension.postCell.paddingRight)
        }
        
        if(pollView.visible()) {
            addArrangedSubview(pollView)
            pollView.anchor(left: leftAnchor, right: rightAnchor,
                            leftConstant: Style.dimension.postCell.paddingLeft, rightConstant: Style.dimension.postCell.paddingRight)
        }
        
        if(wikiView.visible()) {
            addArrangedSubview(wikiView)
            wikiView.anchor(left: leftAnchor, right: rightAnchor,
                            leftConstant: Style.dimension.postCell.paddingLeft, rightConstant: Style.dimension.postCell.paddingRight)
        }
        
        if(imageFileSourcesView.visible()) {
            addArrangedSubview(imageFileSourcesView)
        }
        if(documentFileSourcesView.visible()) {
            addArrangedSubview(documentFileSourcesView)
        }
        
        setupBottomMargin()
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
        let subviewWidth = PostAdditionalView.estimateSubviewWidth(width: width)
        var isPostImageFileSourcesViewLastAdditionalView = false
        var rowCount = 0
        
        let surveyHeight = SurveyView.estimateHeight(post: post, width: subviewWidth)
        if surveyHeight > 0 {
            rowCount += 1
        }
        
        let pollHeight = PollView.estimateHeight(post: post, width: subviewWidth)
        if pollHeight > 0 {
            rowCount += 1
        }
        
        let linkSourceHeight = LinkSourceView.estimateHeight(post: post, width: subviewWidth)
        if linkSourceHeight > 0 {
            rowCount += 1
        }

        let wikiHeight = WikiView.estimateHeight(post: post, width: subviewWidth)
        if wikiHeight > 0 {
            rowCount += 1
        }
        
        // 양 사이드 마진없이 전체 폭으로 이미지를 위치시킨다.
        let imageFileSourcesWidth = width
        let imageFileSourcesHeight = PostImageFileSourcesView.estimateHeight(post: post, width: imageFileSourcesWidth)
        if imageFileSourcesHeight > 0 {
            rowCount += 1
            isPostImageFileSourcesViewLastAdditionalView = true
        }
        
        let documentFileSourcesHeight = PostDocumentFileSourcesView.estimateHeight(post: post, width: subviewWidth)
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
        
        return surveyHeight + pollHeight + linkSourceHeight + wikiHeight + imageFileSourcesHeight + documentFileSourcesHeight + bottomMargin + rowsSpace
    }
    
    static func estimateSubviewWidth(width: CGFloat) -> CGFloat {
        return width - Style.dimension.postCell.paddingLeft - Style.dimension.postCell.paddingRight
    }
}
