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
    var forceWidth = CGFloat(0) {
        didSet {
            if post != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
        }
    }
    
    var post: Post? {
        didSet {
            removeAllArrangedSubviews()
            
            if let post = post {
                let fileSourcesOnlyImage = post.fileSourcesOnlyImage()
                if !fileSourcesOnlyImage.isEmpty {
                    let chunck = PostImageFileSourcesView.chunk(fileSourcesOnlyImage: fileSourcesOnlyImage)
                    for fileSources in chunck {
                        guard let subview = buildImagesRow(fileSources: fileSources) else { continue }
                        addArrangedSubview(subview)
                    }
                }
            }
            setNeedsLayout()
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
            let fileSource = fileSources[0]
            let height = fileSource.estimateHeight(width: forceWidth, maxHeight: Style.dimension.postCell.firstImageFileSourceMaxHeight)

            let imageContainer = UIView()
            imageContainer.anchor(heightConstant: height)
            
            let imageView = UIImageView()
            imageView.kf.setImage(with: URL(string: fileSource.attachmentMdUrl))
            imageView.clipsToBounds = true
            
            imageContainer.addSubview(imageView)
            imageView.fillSuperview()
            
            return imageContainer
        default:
            let rowStackView = buildMultiImagesRowStackView(columnCount: fileSources.count)
            for (index, subview) in rowStackView.arrangedSubviews.enumerated() {
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
    
    func visible() -> Bool {
        return !subviews.isEmpty
    }
    
    static func estimateBottomMarginIfLastAdditionalView(post: Post?, defaultMargin: CGFloat) -> CGFloat {
        guard let post = post else { return CGFloat(0) }
        if post.fileSourcesOnlyImage().count == 1 {
            return CGFloat(0)
        } else if post.fileSourcesOnlyImage().count > 1 {
            return Style.dimension.postCell.imageFileSourceSpace
        } else {
            return defaultMargin
        }
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        guard let post = post else { return CGFloat(0) }

        let fileSourcesOnlyImage = post.fileSourcesOnlyImage()
        if !fileSourcesOnlyImage.isEmpty {
            let chunk = PostImageFileSourcesView.chunk(fileSourcesOnlyImage: fileSourcesOnlyImage)
            guard let firstRow = chunk.first else { return CGFloat(0) }
            
            var result = CGFloat(0)
            if firstRow.count <= 1 {
                let firstImagesHeight = fileSourcesOnlyImage[0].estimateHeight(width: width, maxHeight: Style.dimension.postCell.firstImageFileSourceMaxHeight)
                result += firstImagesHeight
            } else {
                result += Style.dimension.postCell.remainImageFileSourceHeight
            }
            
            let rowCount = chunk.count
            let rowSpaceCount = rowCount - 1
            result += CGFloat(rowCount - 1) * Style.dimension.postCell.remainImageFileSourceHeight
            result += CGFloat(rowSpaceCount) * Style.dimension.postCell.imageFileSourceSpace
            return result
        }
        
        return CGFloat(0)
    }
}
