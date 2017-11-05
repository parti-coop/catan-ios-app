//
//  CommentCell.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 11. 6..
//  Copyright © 2017년 Parti. All rights reserved.
//

import LBTAComponents

class CommentCell: DatasourceCell {
    override var datasourceItem: Any? {
        didSet {
            guard let comment = datasourceItem as? Comment else { return }
            
            commentView.comment = comment
        }
    }
    
    let commentView: CommentView = {
        let view = CommentView()
        return view
    }()
    
    override func setupViews() {
        addSubview(commentView)
        commentView.forceWidth = frame.width
        commentView.fillSuperview()
    }
}
