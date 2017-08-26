//
//  CatanLabel.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 25..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class CatanLabel: UILabel {
    public init(text: String? = nil, font: UIFont? = nil) {
        super.init(frame: .zero)
        self.text = text
        self.font = font
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func estimateHeight(text: String, width: CGFloat, of prototype: CatanLabel) -> CGFloat {
        let dummayPostTitleTextView = CatanLabel()
        dummayPostTitleTextView.text = text
        dummayPostTitleTextView.font = prototype.font
        return dummayPostTitleTextView.estimateHeight(width: width)
    }

    fileprivate func estimateHeight(width: CGFloat) -> CGFloat {
        let textContainer: NSTextContainer = {
            let size = CGSize(width: width, height: .greatestFiniteMagnitude)
            let container = NSTextContainer(size: size)
            container.lineFragmentPadding = 0
            return container
        }()
        
        guard let textStorage = textStorage() else { return CGFloat(0) }
        
        let layoutManager: NSLayoutManager = {
            let layoutManager = NSLayoutManager()
            layoutManager.addTextContainer(textContainer)
            textStorage.addLayoutManager(layoutManager)
            return layoutManager
        }()
        
        let rect = layoutManager.usedRect(for: textContainer)
        return rect.size.height
    }
    
    fileprivate func textStorage() -> NSTextStorage? {
        if let text = text {
            return NSTextStorage(string: text)
        }
        if let attributedText = attributedText {
            return NSTextStorage(attributedString: attributedText)
        }
        
        return nil
    }
}
