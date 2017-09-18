//
//  SurveyView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 10..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import LBTAComponents

class SurveyView: UIView {
    static let prototype = SurveyView()
    
    weak var cellRefetchable: CellRefetchable? {
        didSet {
            setupPostReloadableToOptionsView()
        }
    }
    
    func setupPostReloadableToOptionsView() {
        for view in optionsView.arrangedSubviews {
            guard let optionVew = view as? OptionView else { continue }
            optionVew.cellRefetchable = cellRefetchable
        }
    }
    
    var forceWidth = CGFloat(0) {
        didSet {
            if post != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
        }
    }
    
    // MARK: 컴포넌트
    
    let optionsView: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        view.axis = .vertical
        view.spacing = 0
        return view
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .app_light_gray
        return view
    }()
    
    let metaLabel: LBTATextView = {
        let label = LBTATextView()
        label.textColor = .app_gray
        label.font = Style.font.smallThin
        return label
    }()
    
    // MARK: 데이터
    
    var post: Post? {
        didSet {
            guard let survey = post?.survey else { return }
            
            optionsView.removeAllArrangedSubviews()
            
            for option in survey.options {
                let optionView = OptionView(forceWidth: SurveyView.estimateOptionsWidth(width: forceWidth))
                optionView.option = option
                optionView.survey = survey
                optionsView.addArrangedSubview(optionView)
            }
            setupPostReloadableToOptionsView()
            
            metaLabel.text = " \(survey.remainTimeHuman)"
            if survey.feedbackUsersCount > 0 {
                metaLabel.text = "\(metaLabel.text ?? "") · 총투표 \(survey.feedbackUsersCount)명"
            }
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
        
        addSubview(optionsView)
        addSubview(dividerView)
        addSubview(metaLabel)
        
        optionsView.anchor(topAnchor, left: leftAnchor, right: rightAnchor,
                           topConstant: Style.dimension.postCell.surveyPadding, leftConstant: Style.dimension.postCell.surveyPadding, rightConstant: Style.dimension.postCell.surveyPadding)
        dividerView.anchor(optionsView.bottomAnchor, left: leftAnchor, right: rightAnchor,
                           topConstant: Style.dimension.postCell.surveyPadding, leftConstant: 0, rightConstant: 0,
                           heightConstant: Style.dimension.defaultDividerHeight)
        metaLabel.anchor(dividerView.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                         topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0)
        
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
        guard let survey = post?.survey else { return CGFloat(0) }
        
        var height = CGFloat(0)
        for option in survey.options {
            height += OptionView.estimateHeight(survey: survey, option: option, width: estimateOptionsWidth(width: width))
        }
        height += Style.dimension.postCell.surveyPadding + Style.dimension.postCell.surveyPadding
            + Style.dimension.defaultDividerHeight
            + Style.dimension.postCell.optionMetaHeight
        
        return height
    }
    
    static func estimateOptionsWidth(width: CGFloat) -> CGFloat {
        return width - Style.dimension.postCell.surveyPadding - Style.dimension.postCell.surveyPadding
    }
}
