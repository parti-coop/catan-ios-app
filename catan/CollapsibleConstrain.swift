//
//  UIView+Extension.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 27..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class CollapsibleConstraint {
    fileprivate let view: UIView
    fileprivate var topConstraint: NSLayoutConstraint?
    fileprivate var heightEqualToConstraint: NSLayoutConstraint?
    fileprivate var topConstant: CGFloat?
   
    public init(_ view: UIView) {
        self.view = view
    }
    
    func setupCollapsibleConstraint(top: NSLayoutYAxisAnchor, topConstant: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        self.topConstraint = view.topAnchor.constraint(equalTo: top, constant: 0)
        self.topConstraint?.isActive = true
        self.heightEqualToConstraint = view.heightAnchor.constraint(equalToConstant: 0)
        self.heightEqualToConstraint?.isActive = true
        self.topConstant = topConstant
    }
    
    func hide() {
        guard let topConstraint = topConstraint, let heightEqualToConstraint = heightEqualToConstraint else { return }
        topConstraint.constant = 0
        heightEqualToConstraint.constant = 0
    }
    
    func show(height: CGFloat) {
        guard let topConstraint = topConstraint, let topConstant = topConstant, let heightEqualToConstraint = heightEqualToConstraint else { return }
        topConstraint.constant = topConstant
        heightEqualToConstraint.constant = height
    }
}
