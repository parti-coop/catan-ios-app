//
//  NSAttributedString+Extension.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 27..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

extension NSAttributedString {
    func debugHeightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        return CGFloat(200)
    }
    
    func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
        let dummyTextStorage = NSTextStorage(attributedString: self)
        let dummyTextContainer: NSTextContainer = {
            let size = CGSize(width: width, height: .greatestFiniteMagnitude)
            let container = NSTextContainer(size: size)
            container.lineFragmentPadding = 0
            container.maximumNumberOfLines = 0
            return container
        }()
        let dummyLayoutManager: NSLayoutManager = {
            let layoutManager = NSLayoutManager()
            layoutManager.addTextContainer(dummyTextContainer)
            dummyTextStorage.addLayoutManager(layoutManager)
            return layoutManager
        }()
        
        let rect = dummyLayoutManager.usedRect(for: dummyTextContainer)
        return rect.size.height
    }
    
    func trimText() -> NSAttributedString {
        let dummyTextStorage = NSTextStorage(attributedString: self)
        let dummyTextContainer: NSTextContainer = {
            let size = CGSize(width: 1000, height: CGFloat.greatestFiniteMagnitude)
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
        
        let allRange = dummyLayoutManager.glyphRange(for: dummyTextContainer)
        
        var ranges = [NSRange]()
        dummyLayoutManager.enumerateLineFragments(forGlyphRange: allRange, using: { (lineRect, usedRect, textContainer, lineRange, stop) in
            ranges.append(lineRange)
        })
        
        // TODO: 버그가 있는지 체크 필요
        for range in ranges.reversed() {
            if dummyTextStorage.attributedSubstring(from: range).string.isBlank() {
                dummyTextStorage.deleteCharacters(in: range)
            } else {
                break
            }
        }
        
        return dummyTextStorage
    }
    
    // concatenate attributed strings
    static func + (left: NSAttributedString, right: NSAttributedString) -> NSMutableAttributedString {
        let result = NSMutableAttributedString()
        result.append(left)
        result.append(right)
        return result
    }
}
