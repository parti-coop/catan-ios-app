//
//  PostImageFileSourcesView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 3..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import Kingfisher

class PostImageFileSourcesView: UIStackView {
    static let heightCache = HeightCache()
    static let firstImageMaxHeight = CGFloat(1000)
    
    var forceWidth = CGFloat(0) {
        didSet {
            if post != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
        }
    }
    
    var post: Post? {
        didSet {
            removeAllArrangedSubview()
            
            if let post = post {
                let fileSourcesOnlyImage = post.fileSourcesOnlyImage()
                if !fileSourcesOnlyImage.isEmpty {
                    for fileSources in chunk(fileSourcesOnlyImage: fileSourcesOnlyImage) {
                        guard let subview = buildImagesRow(fileSources: fileSources) else { continue }
                        addArrangedSubview(subview)
                    }
                }
            }
            setNeedsLayout()
        }
    }
    
    fileprivate func removeAllArrangedSubview() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    fileprivate func chunk(fileSourcesOnlyImage fileSources: [FileSource]) -> [[FileSource]] {
        var result = [[FileSource]]()
        if fileSources.isEmpty {
            return result
        }
        
        if fileSources.count <= 2 {
            result.append(fileSources)
            return result
        }
        
        let chunkSize = 3
        result += stride(from: 1, to: fileSources.count, by: chunkSize).map {
            Array(fileSources[$0..<min($0 + chunkSize, fileSources.count)])
        }
        
        if let lastResult = result.last, lastResult.count == 1 {
            result[result.endIndex - 1].append(lastResult[0])
            result.removeLast()
        }
        
        return result
    }
    
    fileprivate func buildImagesRow(fileSources: [FileSource]) -> UIView? {
        switch fileSources.count {
        case 1:
            let imageView = UIImageView()
            let targetSize = CGSize(width: forceWidth, height: PostImageFileSourcesView.firstImageMaxHeight)
            imageView.kf.setImage(
                with: URL(string: fileSources[0].attachmentMdUrl),
                options: [.processor(ResizingImageProcessor(targetSize: targetSize, contentMode: .aspectFit))])
            imageView.clipsToBounds = true
            return imageView
        case 2:
            return UIView()
        case 3:
            return UIView()
        default:
            return nil
        }
    }
    
    init() {
        super.init(frame: .zero)
        axis = .vertical
        distribution = .equalSpacing
        spacing = Style.dimension.postCell.imageFileSourceSpace
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
//
//    override var intrinsicContentSize: CGSize {
//        if post == nil || forceWidth <= 0 {
//            return super.intrinsicContentSize
//        }
//
//        let height = estimateIntrinsicContentHeight()
//        return CGSize(width: forceWidth, height: height)
//    }
    
//    fileprivate func estimateIntrinsicContentHeight() -> CGFloat {
//        return PostAdditionalView.estimateHeight(post: self.post, width: forceWidth)
//    }
    
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
