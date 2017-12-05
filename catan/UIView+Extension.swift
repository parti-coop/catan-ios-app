//
//  UIView+Extension.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 11. 20..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

extension UIView {
    func anchorHeightGreaterThanOrEqualTo(_ constant: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(greaterThanOrEqualToConstant: constant).isActive = true
    }
}
