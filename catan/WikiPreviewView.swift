//
//  WikiPreview.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 10. 17..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import KRWordWrapLabel

class WikiPreviewView: UIView {
    // TODO: 높이를 캐시합니다.
    static let heightCache = HeightCache()
    static let prototype = WikiPreviewView()
    
    var forceWidth = CGFloat(0) {
        didSet {
            if post != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
        }
    }
    
    let titleLabel: KRWordWrapLabel = {
        let label = KRWordWrapLabel()
        label.numberOfLines = 0
        label.font = Style.font.defaultBold
        label.textColor = UIColor.app_gray
        return label
    }()
    
    let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var post: Post? {
        didSet {
            if let wiki = post?.wiki {
                titleLabel.text = wiki.title
                previewImageView.kf.setImage(with: URL(string: wiki.thumbnailMdUrl))
            }
            setNeedsLayout()
            invalidateIntrinsicContentSize()
        }
    }

    public init() {
        super.init(frame: .zero)
        backgroundColor = .app_lighter_gray
        layer.borderWidth = Style.dimension.defaultBorderWidth
        layer.borderColor = UIColor.app_light_gray.cgColor
        layer.cornerRadius = Style.dimension.defaultRadius
        layer.masksToBounds = true
        setupView()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        addSubview(titleLabel)
        addSubview(previewImageView)
        
        titleLabel.anchor(topAnchor, left: leftAnchor, right: rightAnchor,
                          topConstant: Style.dimension.postCell.wikiPreviewPadding,
                          leftConstant: Style.dimension.postCell.wikiPreviewPadding,
                          rightConstant: Style.dimension.postCell.wikiPreviewPadding)
        previewImageView.anchor(titleLabel.bottomAnchor, left: leftAnchor, right: rightAnchor,
                                topConstant: Style.dimension.postCell.wikiPreviewPadding,
                                leftConstant: 0,
                                rightConstant: 0)
    }
    
    override var intrinsicContentSize: CGSize {
        if post == nil || forceWidth <= 0 {
            return super.intrinsicContentSize
        }
        
        return CGSize(width: forceWidth, height: WikiPreviewView.estimateHeight(post: self.post, width: forceWidth))
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        guard let wiki = post?.wiki else { return CGFloat(0) }
        let textHeight = UILabel.estimateHeight(text: wiki.title, width: width, of: WikiPreviewView.prototype.titleLabel)
        
        return Style.dimension.postCell.wikiPreviewPadding
            + textHeight
            + Style.dimension.postCell.wikiPreviewPadding
            + estimatePreviewImageHeight(wiki: wiki, width: width)
    }
    
    static func estimatePreviewImageHeight(wiki: Wiki, width: CGFloat) -> CGFloat {
        return min(width / CGFloat(wiki.imageRatio), Style.dimension.postCell.wikiPreviewImageMaxHeight)
    }
}
