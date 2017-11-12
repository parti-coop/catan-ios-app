//
//  LargeCollection.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 11. 12..
//  Copyright © 2017년 Parti. All rights reserved.
//

import Foundation

class LargeCollection<T> {
    fileprivate var elements = [T]()
    var isLoadingCompleted = false
    
    func append(_ newElement: T) {
        elements.append(newElement)
    }
    
    func appendAll(_ newElements: [T]) {
        elements += newElements
    }
    
    func prependAll(_ newElements: [T]) {
        elements.insert(contentsOf: newElements, at: 0)
    }
    
    func first() -> T? {
        return elements.first
    }
    
    func currentCount() -> Int {
        return elements.count
    }
    
    func get(indexOf index: Int) -> T? {
        return elements[index]
    }
    
    func lastIndex() -> Int {
        return elements.count - 1
    }
}
