//
//  BottomIndicator.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 23..
//  Copyright © 2017년 Parti. All rights reserved.
//

import LBTAComponents
import UIKit

class IndicatorCell: DatasourceCell {
    override var datasourceItem: Any? {
        didSet {
            indicator.startAnimating()
        }
    }
    
    let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        return indicator
    }()
    
    override func setupViews() {
        addSubview(indicator)

        indicator.isHidden = false
        indicator.hidesWhenStopped = false
        indicator.startAnimating()
        indicator.fillSuperview()
    }
}
