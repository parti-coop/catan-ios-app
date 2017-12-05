//
//  PostCell.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 23..
//  Copyright © 2017년 Parti. All rights reserved.
//

import LBTAComponents
import Kingfisher
import DateToolsSwift
import BonMot

class PostCell: DatasourceCell {
    override var datasourceItem: Any? {
        didSet {
            guard let post = datasourceItem as? Post else { return }
            postView.post = post
            postView.anchor(heightConstant: PostCell.height(post, frame: frame))
            setNeedsLayout()
        }
    }
    
    override weak var controller: DatasourceController? {
        didSet {
            postView.delegate = controller as? PostViewDelegate
        }
    }
    
    let postView = PostView()
    
    override func setupViews() {
        separatorLineView.isHidden = false
        separatorLineView.backgroundColor = UIColor.app_light_gray
        postView.setupViews(width: frame.width)

        addSubview(postView)
        postView.fillSuperview()
    }
    
    static func height(_ post: Post, frame: CGRect) -> CGFloat {
        return PostView.height(post, width: frame.width)
    }
}
