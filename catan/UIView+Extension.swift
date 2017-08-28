//
//  CollapsibleUIView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 28..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import Foundation

private var collapsibleConstraintKey: UInt8 = 0
extension UIView {
    fileprivate var collapsibleConstraint: CollapsibleConstraint { // cat is *effectively* a stored property
        get {
            return associatedObject(base: self, key: &collapsibleConstraintKey)
            { return CollapsibleConstraint(self) } // Set the initial value of the var
        }
        set { associateObject(base: self, key: &collapsibleConstraintKey, value: newValue) }
    }
    
    func collapsable(_ top: NSLayoutYAxisAnchor, topConstant: CGFloat) {
        collapsibleConstraint.setupCollapsibleConstraint(top: top, topConstant: topConstant)
    }
    
    func collapse(out height: CGFloat = 0) {
        if(height == 0) {
            collapsibleConstraint.hide()
        } else {
            collapsibleConstraint.show(height: height)
        }
    }

    func associatedObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, initialiser: () -> ValueType) -> ValueType {
            if let associated = objc_getAssociatedObject(base, key)
                as? ValueType { return associated }
            let associated = initialiser()
            objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
            return associated
    }
    
    func associateObject<ValueType: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, value: ValueType) {
        objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
    }
}

