//
//  HeightCache.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 26..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class HeightCache {
    var caches = [CGFloat : NSCache<NSString, NSNumber>]()
    
    func height(forKey key: Int, onWidth width: CGFloat) -> CGFloat? {
        guard let cache = caches[width], let number = cache.object(forKey: NSString(string: "\(key)")) else { return nil }
        return CGFloat(number)
    }
    
    func setHeight(_ height: CGFloat, forKey key: Int, onWidth width: CGFloat) {
        if caches[width] == nil {
            caches[width] = NSCache<NSString, NSNumber>()
        }
        caches[width]?.setObject(NSNumber(value: Float(height)), forKey: NSString(string: "\(key)"))
    }
    
    func purgeHeight(forKey key: Int, onWidth width: CGFloat) {
        guard let cache = caches[width] else { return }
        cache.removeObject(forKey: NSString(string: "\(key)"))
    }
}
