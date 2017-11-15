//
//  LinkSourceView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 7..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import BonMot

class LinkSourceView: UIStackView {
    static let prototype = LinkSourceView()
    
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
            if let linkSource = post?.linkSource {
                if linkSource.imageUrl.isPresent() {
                    addArrangedSubview(imageView)
                    
                    let height = Style.dimension.postCell.linkSourceImageSize
                    imageView.anchor(widthConstant: forceWidth, heightConstant: height)
                    
                    let roundedRect = CGRect(x: 0, y: 0, width: forceWidth, height: height)
                    let path = UIBezierPath(roundedRect: roundedRect, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: Style.dimension.defaultRadius, height: Style.dimension.defaultRadius))
                    let mask = CAShapeLayer()
                    mask.path = path.cgPath
                    mask.frame = roundedRect
                    imageView.layer.mask = mask
                    imageView.kf.setImage(with: URL(string: linkSource.imageUrl))
                }
                
                if linkSource.title.isPresent() {
                    addArrangedSubview(titleLabel)
                    titleLabel.text = linkSource.title
                    titleLabel.anchor(left: leftAnchor, right: rightAnchor,
                                      leftConstant: Style.dimension.postCell.linkSourceDesciptionPadding, rightConstant: Style.dimension.postCell.linkSourceDesciptionPadding)
                    
                }
                
                if linkSource.body.isPresent() {
                    addArrangedSubview(bodyLabel)
                    bodyLabel.text = linkSource.body
                    bodyLabel.anchor(left: leftAnchor, right: rightAnchor,
                                     leftConstant: Style.dimension.postCell.linkSourceDesciptionPadding, rightConstant: Style.dimension.postCell.linkSourceDesciptionPadding)
                }
                
                if linkSource.siteName.isPresent() {
                    addArrangedSubview(siteNameLabel)
                    siteNameLabel.attributedText = LinkSourceView.buildSiteNameText(linkSource: linkSource)
                    siteNameLabel.anchor(left: leftAnchor, right: rightAnchor,
                                         leftConstant: Style.dimension.postCell.linkSourceDesciptionPadding, rightConstant: Style.dimension.postCell.linkSourceDesciptionPadding)
                }
                
            }
            
            setNeedsLayout()
        }
    }
    
    static fileprivate func buildSiteNameText(linkSource: LinkSource) -> NSAttributedString {
        return NSAttributedString.composed(of: [
            #imageLiteral(resourceName: "external_link").withRenderingMode(.alwaysOriginal).tintedImage(color: .app_gray).styled(with: .baselineOffset(-2)),
            Special.noBreakSpace,
            linkSource.siteName])
    }
    
    let borderView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.app_light_gray.cgColor
        view.layer.cornerRadius = Style.dimension.defaultRadius
        view.layer.masksToBounds = true
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Style.font.largeThin
        label.textColor = UIColor.app_gray
        label.numberOfLines = 2
        label.preservesSuperviewLayoutMargins = true
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = Style.font.defaultNormal
        label.textColor = UIColor.app_gray
        label.numberOfLines = 3
        return label
    }()
    
    let siteNameLabel: UILabel = {
        let label = UILabel()
        label.font = Style.font.smallNormal
        label.textColor = UIColor.app_gray
        label.numberOfLines = 1
        return label
    }()
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.app_light_gray.cgColor
        
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleLink))
        addGestureRecognizer(tap)
    }
    
    fileprivate func setupViews() {
        distribution = .equalSpacing
        axis = .vertical
        spacing = Style.dimension.defaultSpace
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: Style.dimension.postCell.linkSourceDesciptionPadding, right: 0)
        
        addSubview(borderView)
        borderView.fillSuperview()
    }
    
    func handleLink() {
        if let urlString = post?.linkSource?.url, let url = URL(string: urlString) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: forceWidth, height: LinkSourceView.estimateHeight(post: post, width: forceWidth))
    }
    
    func visible() -> Bool {
        return post?.linkSource != nil
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        guard let post = post, let linkSource = post.linkSource else { return CGFloat(0) }
        
        let descriptionPadding = Style.dimension.postCell.linkSourceDesciptionPadding + Style.dimension.postCell.linkSourceDesciptionPadding
        let descriptionHeight = estimateDescriptionHeight(linkSource: linkSource, width: width) + descriptionPadding
        return descriptionHeight + Style.dimension.postCell.linkSourceImageSize + 2
    }
    
    static func estimateDescriptionHeight(linkSource: LinkSource, width: CGFloat) -> CGFloat {
        var subviewsCount = 0
        let titleHeight = UILabel.estimateHeight(text: linkSource.title,
                                                    width: intrinsicDescriptionWidth(width: width),
                                                    of: LinkSourceView.prototype.titleLabel)
        if !linkSource.title.isBlank() { subviewsCount += 1 }
        let bodyHeight = UILabel.estimateHeight(text: linkSource.body,
                                                   width: intrinsicDescriptionWidth(width: width),
                                                   of: LinkSourceView.prototype.bodyLabel)
        if !linkSource.body.isBlank() { subviewsCount += 1 }
        let siteNameHeight = UILabel.estimateHeight(attributedText: buildSiteNameText(linkSource: linkSource),
                                                       of: LinkSourceView.prototype.siteNameLabel,
                                                       width: intrinsicDescriptionWidth(width: width))
        if !linkSource.siteName.isBlank() { subviewsCount += 1 }
        let space = CGFloat(subviewsCount - 1) * Style.dimension.defaultSpace
        return titleHeight + bodyHeight + siteNameHeight + space
    }
    
    static func intrinsicDescriptionWidth(width: CGFloat) -> CGFloat {
        return width - 1 - Style.dimension.postCell.linkSourceDesciptionPadding - Style.dimension.postCell.linkSourceDesciptionPadding - 1
    }
}
