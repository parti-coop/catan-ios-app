//
//  BufferCollection.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 11. 12..
//  Copyright © 2017년 Parti. All rights reserved.
//

import Foundation

class BufferCollection<T>: Sequence {
    fileprivate var elements = [T]()
    var isLoadingCompleted = false
    
    func append(_ newElement: T) {
        elements.append(newElement)
    }
    
    func appendAll(_ newElements: [T]) {
        elements += newElements
    }
    
    func prependAll(_ newElements: [T], before beforeIndex: Int = 0) {
        elements.insert(contentsOf: newElements, at: beforeIndex)
    }
    
    func lighten(count: Int){
        if elements.count <= count {
            return
        }
        
        elements.removeFirst(elements.count - count)
        self.isLoadingCompleted = false
    }
    
    func lighten(where predicate: (T) -> Bool) {
        guard let index = self.index(where: predicate) else { return }
        elements.removeFirst(index)
        self.isLoadingCompleted = false
    }
    
    func lightenAll() {
        if elements.count <= 0 {
            return
        }
        
        elements.removeAll()
        self.isLoadingCompleted = false
    }
    
    func last(_ n: Int) -> [T] {
        return Array(elements.suffix(n))
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
    
    func index(where predicate: (T) -> Bool) -> Int? {
        return elements.index(where: predicate)
    }
    
    func lastIndex() -> Int {
        return elements.count - 1
    }
    
    public func makeIterator() -> AnyIterator<T> {
        var nextIndex = 0
        return AnyIterator {
            let currentIndex = nextIndex
            nextIndex += 1
            return self.elements.count > currentIndex ? self.elements[currentIndex] : nil
        }
    }
}
