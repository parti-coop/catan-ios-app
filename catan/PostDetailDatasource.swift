//
//  PostDetailDatasource.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 11. 20..
//  Copyright © 2017년 Parti. All rights reserved.
//

import LBTAComponents
import UIKit

protocol PostDetailDatasourceDelegate: class {
    func setupViews()
    func onLoadPost(post: Post)
}

class PostDetailDatasource {
    var post: Post? {
        didSet {
            guard let post = post else { return }
            delegate?.onLoadPost(post: post)
        }
    }
    var postId: Int?
    
    weak var delegate: PostDetailDatasourceDelegate?
    
    init(controller: PostDetailDatasourceDelegate, postId: Int) {
        self.delegate = controller
        self.postId = postId
    }
    
    func loadData() {
        delegate?.setupViews()

        if let postId = postId {
            fetch(postId: postId)
        }
    }
    
    fileprivate func fetch(postId: Int) {
        PostRequestFactory.fetch(postId: postId).perform(
            withSuccess: { [weak self] (post) in
                guard let strongSelf = self else { return }
                
                strongSelf.setupTexts(post: post)
                strongSelf.post = post
        })
    }
    
    fileprivate func setupTexts(post: Post) {
        post.titleAndBodyAttributedText = PostTitleAndBodyView.buildText(post)
        for comment in post.bufferComments {
            comment.bodyAttributedText = CommentBodyView.buildBodyText(comment)
        }
    }
}
