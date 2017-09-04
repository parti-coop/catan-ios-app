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
                    let chunck = PostImageFileSourcesView.chunk(fileSourcesOnlyImage: fileSourcesOnlyImage)
                    for fileSources in chunck {
                        guard let subview = buildImagesRow(fileSources: fileSources) else { continue }
                        addArrangedSubview(subview)
                    }
                    toggleBottomMargin(fileSources: fileSourcesOnlyImage)
                }
            } else {
                toggleBottomMargin()
            }
            setNeedsLayout()
        }
    }
    
    fileprivate func removeAllArrangedSubview() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    fileprivate static func chunk(fileSourcesOnlyImage fileSources: [FileSource]) -> [[FileSource]] {
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
            let targetSize = CGSize(width: forceWidth, height: Style.dimension.postCell.firstImageFileSourceMaxHeight)
            imageView.kf.setImage(
                with: URL(string: fileSources[0].attachmentMdUrl),
                options: [.processor(ResizingImageProcessor(targetSize: targetSize, contentMode: .aspectFit))])
            imageView.clipsToBounds = true
            return imageView
        default:
            let rowStackView = buildMultiImagesRowStackView(columnCount: fileSources.count)
            for (index, subview) in rowStackView.subviews.enumerated() {
                loadImage(of: fileSources[index], to: subview)
            }
            rowStackView.anchor(heightConstant: Style.dimension.postCell.remainImageFileSourceHeight)
            return rowStackView
        }
    }
    
    fileprivate func buildMultiImagesRowStackView(columnCount: Int) -> UIStackView {
        let rowStackView = UIStackView()
        rowStackView.axis = .horizontal
        rowStackView.distribution = .fillEqually
        rowStackView.spacing = Style.dimension.postCell.imageFileSourceSpace
        
        for _ in 1...columnCount {
            rowStackView.addArrangedSubview(UIView())
        }
        
        return rowStackView
    }
    
    fileprivate func loadImage(of filesource: FileSource, to view: UIView) {
        let imageView = UIImageView()
        imageView.kf.setImage(with: URL(string: filesource.attachmentMdUrl))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill

        view.addSubview(imageView)
        imageView.fillSuperview()
    }
    
    fileprivate func toggleBottomMargin(fileSources: [FileSource] = [FileSource]()) {
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: PostImageFileSourcesView.estimateBottomMargin(fileSources: fileSources), right: 0)
    }
    
    fileprivate static func estimateBottomMargin(fileSources: [FileSource] = [FileSource]()) -> CGFloat {
        return fileSources.count > 1 ? Style.dimension.postCell.imageFileSourceSpace: 0
    }
    
    init() {
        super.init(frame: .zero)
        axis = .vertical
        distribution = .equalSpacing
        spacing = Style.dimension.postCell.imageFileSourceSpace
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
            let chunk = PostImageFileSourcesView.chunk(fileSourcesOnlyImage: fileSourcesOnlyImage)
            guard let firstRow = chunk.first else { return CGFloat(0) }
            
            var result = CGFloat(0)
            if firstRow.count <= 1 {
                let firstImagesHeight = fileSourcesOnlyImage[0].estimateHeight(width: width, maxHeight: PostAdditionalView.firstImageMaxHeight)
                result += firstImagesHeight
            } else {
                result += Style.dimension.postCell.remainImageFileSourceHeight
            }
            
            let rowCount = chunk.count
            let rowSpaceCount = rowCount - 1
            result += CGFloat(rowCount - 1) * Style.dimension.postCell.remainImageFileSourceHeight
            result += CGFloat(rowSpaceCount) * Style.dimension.postCell.imageFileSourceSpace
            result += PostImageFileSourcesView.estimateBottomMargin(fileSources: fileSourcesOnlyImage)
            return result
        }

        
        return CGFloat(0)
    }
}
