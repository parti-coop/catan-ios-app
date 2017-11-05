//
//  CommentsDatasource.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 11. 6..
//  Copyright © 2017년 Parti. All rights reserved.
//

import LBTAComponents
import UIKit

protocol CommentsDatasourceDelegate: NSObjectProtocol {
    func reloadData()
}

class CommentsDatasource: Datasource {
    let post: Post
    var comments = [Comment]()
    weak var controller: CommentsDatasourceDelegate?
    
    init(controller: CommentsDatasourceDelegate, post: Post) {
        self.post = post
        self.controller = controller
        super.init()
        fetchComments()
    }
    
    override func cellClasses() -> [DatasourceCell.Type] {
        return [CommentCell.self]
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        return comments.count
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return comments[indexPath.item]
    }
    
    func fetchComments() {
        PostRequestFactory.fetchComments(postId: post.id).resume { [weak self] (page, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                // TODO: 일반 오류인지, 네트워크 오류인지 처리 필요
                log.error("댓글 로딩 실패 : \(error.localizedDescription)")
//                strongSelf.isFinishedPagination = true
                strongSelf.controller?.reloadData()
                return
            }
            
            guard var page = page else { return }
            
            DispatchQueue.main.async() {
                for (index, _) in page.items.enumerated() {
                    strongSelf.setupTexts(comment: page.items[index])
                }
                strongSelf.comments += page.items
//                strongSelf.isFinishedPagination = !page.hasMoreItem
//                strongSelf.isLoadingMore = false
                strongSelf.controller?.reloadData()
            }
        }
    }
    
    func setupTexts(comment: Comment) {
        comment.bodyAttributedText = CommentBodyView.buildBodyText(comment)
    }
}
