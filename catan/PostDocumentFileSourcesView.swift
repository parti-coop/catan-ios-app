//
//  PostDocumentFileSourcesView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 4..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class PostDocumentFileSourcesView: UIStackView {
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
                let fileSourcesOnlyDocument = post.fileSourcesOnlyDocument()
                for fileSource in fileSourcesOnlyDocument {
                    let subview = buildDocumentRow(fileSource: fileSource)
                    addArrangedSubview(subview)
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
    
    fileprivate func buildDocumentRow(fileSource: FileSource) -> UIView {
        let view = UIView()
        view.layer.borderWidth = 1;
        view.layer.borderColor = UIColor.app_light_gray.cgColor
        view.layer.cornerRadius = Style.dimension.defaultRadius
        view.layer.masksToBounds = true
        view.anchor(heightConstant: 100)
        
        return view
    }
    
    init() {
        super.init(frame: .zero)
        axis = .vertical
        distribution = .equalSpacing
        spacing = Style.dimension.postCell.documentFileSourceSpace
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 0, left: Style.dimension.postCell.paddingLeft, bottom: 0, right: Style.dimension.postCell.paddingRight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func visible() -> Bool {
        return !arrangedSubviews.isEmpty
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        guard let post = post else { return CGFloat(0) }
        
        let fileSourcesOnlyDocument = post.fileSourcesOnlyDocument()
        let rowCount = post.fileSourcesOnlyDocument().count
        let rowsSpace = CGFloat(max(0, rowCount - 1)) * Style.dimension.postCell.documentFileSourceSpace
        
        return CGFloat(fileSourcesOnlyDocument.count * 100) + rowsSpace
    }
}
