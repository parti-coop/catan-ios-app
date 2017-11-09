//
//  OptionView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 13..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import M13Checkbox
import KRWordWrapLabel

class OptionView: UIView {
    static let prototype = OptionView(forceWidth: 0)
    weak var cellRefetchable: CellRefetchable?
    let forceWidth: CGFloat
    
    // MARK: 컴포넌트
    
    let bodyLabel: KRWordWrapLabel = {
        let label = KRWordWrapLabel()
        label.font = Style.font.defaultNormal
        label.textColor = UIColor.app_gray
        label.numberOfLines = 0
        return label
    }()
    
    let checkbox: M13Checkbox = {
        let checkbox = M13Checkbox()
        checkbox.stateChangeAnimation = .fade(.fill)
        checkbox.boxLineWidth = 1
        checkbox.boxType = .circle
        checkbox.cornerRadius = Style.dimension.defaultRadius
        checkbox.tintColor = UIColor.app_gray
        checkbox.addTarget(self, action: #selector(handleFeedback), for: .valueChanged)
        return checkbox
    }()
    
    func handleFeedback() {
        guard let option = option else { return }
        FeedbackRequestFactory.create(optionId: option.id, selected: option.isMySelect == false).resume { [weak self] (response, error) in
            guard let strongSelf = self else { return }
            if let _ = error {
                // TODO: 일반 오류인지, 네트워크 오류인지 처리 필요
                return
            }
            
            strongSelf.cellRefetchable?.refetch()
        }
    }
    
    let bar: UIProgressView = {
        let view = UIProgressView()
        view.layer.borderWidth = 1
        view.trackTintColor = .clear
        view.progressTintColor = .light_brand_primary
        view.layer.cornerRadius = Style.dimension.defaultRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .app_gray
        label.font = Style.font.tinyNormal
        return label
    }()
    
    let mvpLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = " 최다득표 "
        label.backgroundColor = .brand_primary
        label.font = Style.font.tinyNormal
        label.layer.cornerRadius = Style.dimension.defaultRadius
        label.layer.masksToBounds = true
        return label
    }()
    
    // MARK: 모델
    
    var option: Option? {
        didSet {
            guard let option = option else { return }
            
            setupOption(option)
            
            setNeedsLayout()
        }
    }
    
    fileprivate func setupOption(_ option: Option) {
        bodyLabel.text = option.body
        checkbox.checkState = option.isMySelect ? .checked : .unchecked
        checkbox.tintColor = option.isMySelect ? UIColor.brand_primary : UIColor.app_gray
        bar.layer.borderColor = option.isMySelect ? UIColor.brand_primary.cgColor : UIColor.app_light_gray.cgColor
        bar.progress = option.percentage / 100
        countLabel.text = option.feedbacksCount > 0 ? "\(option.feedbacksCount)명" : ""
        mvpLabel.isHidden = !option.isMvp
    }
    
    var survey: Survey? {
        didSet {
            guard let survey = survey else { return }
            
            checkbox.boxType = survey.multipleSelect ? .square : .circle
            toggleBar(survey: survey)

            setNeedsLayout()
        }
    }
    
    fileprivate func toggleBar(survey: Survey?) {
        guard let survey = survey else { return }
        bar.isHidden = !survey.isFeedbackedByMe
    }
    
    // MARK: 기능
    
    init(forceWidth: CGFloat) {
        self.forceWidth = forceWidth
        super.init(frame: .zero)
        setupView()
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleTouch))
        addGestureRecognizer(tap)
    }
    
    func handleTouch() {
        //checkbox.toggleCheckState(true)
        handleFeedback()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    fileprivate func setupView() {
        addSubview(bodyLabel)
        addSubview(checkbox)
        addSubview(bar)
        bar.addSubview(countLabel)
        bar.addSubview(mvpLabel)
        
        let checkboxTopConstant = Style.dimension.defaultSpace + 2
        checkbox.anchor(topAnchor, left: leftAnchor,
                        topConstant: checkboxTopConstant, leftConstant: 0,
                        widthConstant: Style.dimension.postCell.optionCheckSize, heightConstant: Style.dimension.postCell.optionCheckSize)
        bodyLabel.anchor(topAnchor, left: checkbox.rightAnchor, right: rightAnchor,
                         topConstant: Style.dimension.defaultSpace, leftConstant: Style.dimension.defaultSpace, rightConstant: 0)
        bar.anchor(bodyLabel.bottomAnchor, left: bodyLabel.leftAnchor, right: bodyLabel.rightAnchor,
                   topConstant: Style.dimension.defaultSpace, leftConstant: 0, rightConstant: 0,
                   heightConstant: Style.dimension.postCell.optionBarHeight)
        countLabel.anchor(left: bar.leftAnchor,
                          leftConstant: Style.dimension.defaultSpace)
        countLabel.centerYAnchor.constraint(equalTo: bar.centerYAnchor).isActive = true
        mvpLabel.anchor(right: bar.rightAnchor,
                        rightConstant: Style.dimension.defaultSpace)
        mvpLabel.centerYAnchor.constraint(equalTo: bar.centerYAnchor).isActive = true
    }
    
    override var intrinsicContentSize: CGSize {
        if option == nil || forceWidth <= 0 {
            return super.intrinsicContentSize
        }
        
        let height = estimateIntrinsicContentHeight()
        return CGSize(width: forceWidth, height: height)
    }
    
    fileprivate func estimateIntrinsicContentHeight() -> CGFloat {
        return OptionView.estimateHeight(survey: survey, option: self.option, width: forceWidth)
    }
    
    static func estimateHeight(survey: Survey?, option: Option?, width: CGFloat) -> CGFloat {
        guard let survey = survey else { return CGFloat(0) }
        
        let bodyTextHeight = OptionView.estimateBodyHeight(option: option, width: width)
        let barHeightAndMargin = survey.isFeedbackedByMe ? Style.dimension.postCell.optionBarHeight + Style.dimension.defaultSpace : 0
        
        return Style.dimension.defaultSpace
            + bodyTextHeight
            + barHeightAndMargin
            + Style.dimension.defaultSpace
    }
    
    static func estimateBodyHeight(option: Option?, width: CGFloat) -> CGFloat {
        guard let option = option else { return CGFloat(0) }
        
        let bodyTextWidth = OptionView.estimateOptionBodyViewWidth(width: width)
        
        return UILabel.estimateHeight(text: option.body, width: bodyTextWidth, of: OptionView.prototype.bodyLabel)
    }
    
    static fileprivate func estimateOptionBodyViewWidth(width: CGFloat) -> CGFloat {
        return width
            - Style.dimension.postCell.optionCheckSize
            - Style.dimension.defaultSpace
    }
}
