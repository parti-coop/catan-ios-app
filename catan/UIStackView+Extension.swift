//
//  UIStackView+Extension.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 10..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

extension UIStackView {
    func removeAllArrangedSubviews() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}
