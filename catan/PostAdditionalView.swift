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
    static let heightCache = HeightCache()
    static let firstImageMaxHeight = CGFloat(1000)
    
    var forceWidth = CGFloat(0) {
        didSet {
            if post != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
            imageFileSourcesView.forceWidth = forceWidth
        }
    }
    
    let firstImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    let imageFileSourcesView: PostImageFileSourcesView = {
        let view = PostImageFileSourcesView()
        return view
    }()
    
    var post: Post? {
        didSet {
            firstImageView.image = nil
            imageFileSourcesView.post = post
            setNeedsLayout()
        }
    }
    
    init() {
        super.init(frame: .zero)
        axis = .vertical
        distribution = .equalSpacing
        
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        addArrangedSubview(imageFileSourcesView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        let imageFileSourcesHeight = PostImageFileSourcesView.estimateHeight(post: post, width: width)
        return imageFileSourcesHeight
    }
}
