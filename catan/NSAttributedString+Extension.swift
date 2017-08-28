//
//  NSAttributedString+Extension.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 27..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

extension NSAttributedString {
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let dummyTextStorage = NSTextStorage(attributedString: self)
        let dummyTextContainer: NSTextContainer = {
            let size = CGSize(width: width, height: .greatestFiniteMagnitude)
            let container = NSTextContainer(size: size)
            container.lineFragmentPadding = 0
            return container
        }()
        let dummyLayoutManager: NSLayoutManager = {
            let layoutManager = NSLayoutManager()
            layoutManager.addTextContainer(dummyTextContainer)
            dummyTextStorage.addLayoutManager(layoutManager)
            return layoutManager
        }()
        
        dummyLayoutManager.glyphRange(for: dummyTextContainer)
        let rect = dummyLayoutManager.usedRect(for: dummyTextContainer)
        return rect.size.height
    }
}
