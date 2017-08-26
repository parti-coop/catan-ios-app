//
//  HeightCache.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 26..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class HeightCache<KeyType : AnyObject> {
    var caches = [CGFloat : NSCache<KeyType, NSNumber>]()
    
    func height(forKey: KeyType, onWidth width: CGFloat) -> CGFloat? {
        guard let cache = caches[width], let number = cache.object(forKey: forKey) else { return nil }
        return CGFloat(number)
    }
    
    func setHeight(_ height: CGFloat, forKey key: KeyType, onWidth width: CGFloat) {
        if caches[width] == nil {
            caches[width] = NSCache<KeyType, NSNumber>()
        }
        caches[height]?.setObject(NSNumber(value: Float(height)), forKey: key)
    }
    
    func purgeHeight(forKey key: KeyType, onWidth width: CGFloat) {
        guard let cache = caches[width] else { return }
        cache.removeObject(forKey: key)
    }
}
