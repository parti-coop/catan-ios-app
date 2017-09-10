//
//  SurveyView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 10..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class SurveyView: UIView {
    static let prototype = SurveyView()
    
    var forceWidth = CGFloat(0) {
        didSet {
            if post != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
        }
    }
    
    var post: Post? {
        didSet {
            guard let survey = post?.survey else { return }
            
            setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    fileprivate func setupView() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.app_light_gray.cgColor
        layer.cornerRadius = Style.dimension.defaultRadius
        layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: SurveyView.intrinsicContentWidth(width: forceWidth), height: SurveyView.estimateHeight(post: post, width: forceWidth))
    }
    
    func visible() -> Bool {
        return SurveyView.visible(post)
    }
    
    static func visible(_ post: Post?) -> Bool {
        return post?.survey != nil
    }
    
    static fileprivate func intrinsicContentWidth(width: CGFloat) -> CGFloat {
        return width - Style.dimension.postCell.paddingLeft - Style.dimension.postCell.paddingRight
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        return CGFloat(SurveyView.visible(post) ? 100 : 0)
    }
}
