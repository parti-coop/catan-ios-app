//
//  UIView+Extension.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 27..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class CollapsibleTopConstraint {
    fileprivate let view: UIView
    
    fileprivate var topConstraint: NSLayoutConstraint
    fileprivate var topConstant: CGFloat
   
    public init(_ view: UIView, top: NSLayoutYAxisAnchor, topConstant: CGFloat = 0) {
        self.view = view
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.topConstraint = view.topAnchor.constraint(equalTo: top, constant: 0)
        self.topConstraint.isActive = true
        self.topConstant = topConstant
    }
    
    func adjustConstant(height: CGFloat) {
        if height > 0 {
            topConstraint.constant = topConstant
        } else {
            topConstraint.constant = 0
        }
        view.setNeedsLayout()
    }
}
