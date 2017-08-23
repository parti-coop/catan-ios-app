//
//  PostCell.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 23..
//  Copyright © 2017년 Parti. All rights reserved.
//

import LBTAComponents

class PostCell: DatasourceCell {
    override var datasourceItem: Any? {
        didSet {
            guard let post = datasourceItem as? String else { return }
            titleLabel.text = post
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Style.DEFAULT_FONT
        return label
    }()
    
    override func setupViews() {
        separatorLineView.isHidden = false
        separatorLineView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.fillSuperview()
    }
}
