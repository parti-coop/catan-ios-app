//
//  CommentsDatasource.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 11. 6..
//  Copyright © 2017년 Parti. All rights reserved.
//

import LBTAComponents
import UIKit

protocol CommentsDatasourceDelegate: class {
    func reloadData(isScrollToBottom: Bool)
}

class CommentsDatasource: Datasource {
    let post: Post
    weak var controller: CommentsDatasourceDelegate?
    
    init(controller: CommentsDatasourceDelegate, post: Post) {
        self.post = post
        self.controller = controller
        super.init()
    }
    
    override func cellClasses() -> [DatasourceCell.Type] {
        return [CommentCell.self]
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        return post.bufferComments.currentCount()
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return post.bufferComments.get(indexOf: indexPath.item)
    }
    
    override func headerClasses() -> [DatasourceCell.Type]? {
        return [IndicatorCell.self]
    }
    
    override func footerClasses() -> [DatasourceCell.Type]? {
        return [IndicatorCell.self]
    }
    
    override func footerItem(_ section: Int) -> Any? {
        return nil
    }
    
    func emptyComments() {
        post.bufferComments.lightenAll()
    }
    
    func fetchComments() {
        if post.bufferComments.isLoadingCompleted {
            controller?.reloadData(isScrollToBottom: false)
            return
        }
        
        let lastCommentId = post.bufferComments.first()?.id
        PostRequestFactory.fetchComments(post: post, lastCommentId: lastCommentId).perform(
            with: { [weak self] (page, error) in
                guard let strongSelf = self else { return }
                if let error = error {
                    log.error("댓글 로딩 실패 : \(error.localizedDescription)")
                    strongSelf.controller?.reloadData(isScrollToBottom: false)
                    return
                }
                
                guard let page = page else { return }
                
                for comment in page.items {
                    strongSelf.setupTexts(comment: comment)
                }
                
                let post = strongSelf.post
                
                if let lastCommentId = lastCommentId {
                    post.bufferComments.lighten(where: { (comment) -> Bool in
                        comment.id == lastCommentId
                    })
                }
                post.bufferComments.prependAll(page.items)
                post.bufferComments.isLoadingCompleted = !page.hasMoreItem
                
                DispatchQueue.main.async() {
                    strongSelf.controller?.reloadData(isScrollToBottom: lastCommentId == nil)
                }
        })
    }
    
    func leaveOnlyLastPageComments() {
        post.bufferComments.lighten(count: 30)
    }
    
    func createComment(body: String) {
        CommentRequestFactory.create(postId: post.id, body: body).perform(
            withSuccess: { [weak self] (comment) in
                guard let strongSelf = self else { return }
                strongSelf.setupTexts(comment: comment)
                strongSelf.post.add(newComment: comment)
            }, finally: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.controller?.reloadData(isScrollToBottom: true)
            })
    }
    
    func setupTexts(comment: Comment) {
        comment.bodyAttributedText = CommentBodyView.buildBodyText(comment)
    }
    
    func lastIndex() -> IndexPath {
        return IndexPath(item: post.bufferComments.lastIndex(), section: 0)
    }
}
