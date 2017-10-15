//
//  UILabel+Extension.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 10. 15..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

extension UILabel {
    func anchorHeightGreaterThanOrEqualTo(_ constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
    }
    
    static func estimateHeight(text: String, width: CGFloat, of prototype: UILabel, greaterThanOrEqualToHeight: CGFloat = 0) -> CGFloat {
        let dummyView = UILabel()
        dummyView.text = text
        dummyView.font = prototype.font
        dummyView.numberOfLines = prototype.numberOfLines
        dummyView.lineBreakMode = prototype.lineBreakMode
        return max(dummyView.estimateContentHeight(width: width), greaterThanOrEqualToHeight) + estimatePadding(text: text, prototype: prototype)
    }
    
    static func estimateHeight(attributedText: NSAttributedString, of prototype: UILabel, width: CGFloat) -> CGFloat {
        let dummyView = UILabel()
        dummyView.attributedText = attributedText
        dummyView.numberOfLines = prototype.numberOfLines
        dummyView.lineBreakMode = prototype.lineBreakMode
        return dummyView.estimateContentHeight(width: width) + estimatePadding(text: attributedText.string, prototype: prototype)
    }
    
    fileprivate static func estimatePadding(text: String, prototype: UILabel) -> CGFloat {
        guard let label = prototype as? PaddingLabel, text.isPresent() else { return CGFloat(0) }
        
        return label.topInset + label.bottomInset
    }
    
    fileprivate func estimateContentHeight(width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        return sizeThatFits(size).height
    }
}
