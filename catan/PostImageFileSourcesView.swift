//
//  PostImageFileSourcesView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 3..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import Kingfisher

class PostImageFileSourcesView: UIView {
    static let heightCache = HeightCache()
    static let firstImageMaxHeight = CGFloat(1000)
    
    var forceWidth = CGFloat(0) {
        didSet {
            if post != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
        }
    }
    
    let firstImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var post: Post? {
        didSet {
            firstImageView.image = nil
            
            if let post = post {
                let fileSourcesOnlyImage = post.fileSourcesOnlyImage()
                if !fileSourcesOnlyImage.isEmpty {
                    let targetSize = CGSize(width: forceWidth, height: PostImageFileSourcesView.firstImageMaxHeight)
                    firstImageView.kf.setImage(
                        with: URL(string: fileSourcesOnlyImage[0].attachmentMdUrl),
                        options: [.processor(ResizingImageProcessor(targetSize: targetSize, contentMode: .aspectFit))])
                    firstImageView.clipsToBounds = true
                }
            }
            
            setNeedsLayout()
        }
    }
    
    init() {
        super.init(frame: .zero)
        setupViews()
    }
    
    fileprivate func setupViews() {
        addSubview(firstImageView)
        firstImageView.fillSuperview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        if post == nil || forceWidth <= 0 {
            return super.intrinsicContentSize
        }

        let height = estimateIntrinsicContentHeight()
        return CGSize(width: forceWidth, height: height)
    }
    
    fileprivate func estimateIntrinsicContentHeight() -> CGFloat {
        return PostAdditionalView.estimateHeight(post: self.post, width: forceWidth)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        guard let post = post else { return CGFloat(0) }

        let fileSourcesOnlyImage = post.fileSourcesOnlyImage()
        if !fileSourcesOnlyImage.isEmpty {
            let imagesHeight = fileSourcesOnlyImage[0].estimateHeight(width: width, maxHeight: PostAdditionalView.firstImageMaxHeight)
            return imagesHeight
        }
        
        return CGFloat(0)
    }
}
