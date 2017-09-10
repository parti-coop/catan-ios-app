//
//  CatanLabel.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 25..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import KRWordWrapLabel

class CatanLabel: KRWordWrapLabel {
    var greaterThanOrEqualToHeight: CGFloat?
    
    public init(text: String? = nil, font: UIFont? = nil) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func estimateHeight(text: String, width: CGFloat, of prototype: CatanLabel, greaterThanOrEqualToHeight: CGFloat = 0) -> CGFloat {
        let dummyView = CatanLabel()
        dummyView.text = text
        dummyView.font = prototype.font
        dummyView.numberOfLines = prototype.numberOfLines
        dummyView.lineBreakMode = prototype.lineBreakMode
        return max(dummyView.estimateContentHeight(width: width), greaterThanOrEqualToHeight)
    }
    
    static func estimateHeight(attributedText: NSAttributedString, of prototype: CatanLabel, width: CGFloat) -> CGFloat {
        let dummyView = CatanLabel()
        dummyView.attributedText = attributedText
        dummyView.numberOfLines = prototype.numberOfLines
        dummyView.lineBreakMode = prototype.lineBreakMode
        return dummyView.estimateContentHeight(width: width)
    }

    fileprivate func estimateContentHeight(width: CGFloat) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)
        return sizeThatFits(size).height
    }
    
    fileprivate func buildAttributedText() -> NSAttributedString? {
        guard let text = text else { return nil }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byWordWrapping
        return NSAttributedString(string: text, attributes: [ NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle ])
    }
    
    func greaterThanOrEqualToHeight(_ constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        greaterThanOrEqualToHeight = constant
        heightAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
    }

}
