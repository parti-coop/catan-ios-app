//
//  HeightCache.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 26..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

protocol HeightCacheKey {
    func keyForHeightCache() -> Int
    func timestampForHeightCache() -> Double
}

class HeightCache {
    var heightCaches = [CGFloat : NSCache<NSString, NSNumber>]()
    var timestampCaches = [CGFloat : NSCache<NSString, NSNumber>]()
    
    func height(for keyItem: HeightCacheKey, onWidth width: CGFloat) -> CGFloat? {
        let cacheKeyString = NSString(string: "\(keyItem.keyForHeightCache())")
        guard let heightCache = heightCaches[width],
            let lastHeight = heightCache.object(forKey: cacheKeyString),
            let timestampCache = timestampCaches[width],
            let lastTimestamp = timestampCache.object(forKey: cacheKeyString)
        else { return nil }
        
        if lastTimestamp != NSNumber(value: Double(keyItem.timestampForHeightCache())) {
            heightCache.removeObject(forKey: cacheKeyString)
            timestampCache.removeObject(forKey: cacheKeyString)
            return nil
        }
        return CGFloat(truncating: lastHeight)
    }
    
    func setHeight(_ height: CGFloat, for keyItem: HeightCacheKey, onWidth width: CGFloat) {
        if heightCaches[width] == nil {
            heightCaches[width] = NSCache<NSString, NSNumber>()
        }
        if timestampCaches[width] == nil {
            timestampCaches[width] = NSCache<NSString, NSNumber>()
        }
        
        let cacheKeyString = NSString(string: "\(keyItem.keyForHeightCache())")
        heightCaches[width]?.setObject(NSNumber(value: Float(height)), forKey: cacheKeyString)
        timestampCaches[width]?.setObject(NSNumber(value: Float(keyItem.timestampForHeightCache())), forKey: cacheKeyString)
    }
}
