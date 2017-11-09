//
//  PostDatasource.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 23..
//  Copyright © 2017년 Parti. All rights reserved.
//

import LBTAComponents
import TRON
import SwiftyJSON
import UIKit

protocol DashboardDatasourceDelegate: NSObjectProtocol {
    func reloadData()
}

class DashboardDatasource: Datasource {
    static let POST_SECTION = 0
    static let BOTTOM_INDICATOR_SECTION = 1

    var posts = [Post]()
    var isFinishedPagination = false
    var isLoadingMore = false
    weak var controller: DashboardDatasourceDelegate?

    init(controller: DashboardDatasourceDelegate) {
        self.controller = controller
        super.init()
        fetchPosts()
    }
    
    override func cellClasses() -> [DatasourceCell.Type] {
        return [PostCell.self, IndicatorCell.self]
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        if section == DashboardDatasource.POST_SECTION {
            return posts.count
        } else if section == DashboardDatasource.BOTTOM_INDICATOR_SECTION {
            return isFinishedPagination ? 0 : 1
        }
        
        return super.numberOfItems(section)
    }
    
    override func numberOfSections() -> Int {
        return 2
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        if indexPath.section == DashboardDatasource.POST_SECTION {
            return posts[indexPath.item]
        }
        
        return super.item(indexPath)
    }
    
    func fetchPosts() {
        if self.isLoadingMore {
            return
        }
        self.isLoadingMore = true
       
        let lastPostId = posts.last?.id
        PostRequestFactory.fetchPageOnDashBoard(lastPostId: lastPostId).resume { [weak self] (page, error) in
            guard let strongSelf = self else { return }
            if let error = error {
                // TODO: 일반 오류인지, 네트워크 오류인지 처리 필요
                log.error("게시글 로딩 실패 : \(error.localizedDescription)")
                strongSelf.isFinishedPagination = true
                strongSelf.isLoadingMore = false
                strongSelf.controller?.reloadData()
                return
            }
            
            guard var page = page else { return }
            
            DispatchQueue.main.async() {
                for (index, _) in page.items.enumerated() {
                    strongSelf.setupTexts(post: page.items[index])
                }
                strongSelf.posts += page.items
                strongSelf.isFinishedPagination = !page.hasMoreItem
                strongSelf.isLoadingMore = false
                strongSelf.controller?.reloadData()
            }
        }
    }
    
    func fetch(post: Post) {
        PostRequestFactory.fetch(postId: post.id).resume { [weak self] (post, error) in
            guard let strongSelf = self, let reloadedPost = post else { return }
            
            guard let index = strongSelf.posts.index(where: { (post) -> Bool in
                post.id == reloadedPost.id
            }) else { return }
            
            strongSelf.setupTexts(post: reloadedPost)
            strongSelf.posts[index] = reloadedPost
            
            strongSelf.controller?.reloadData()
        }
    }
    
    func setupTexts(post: Post) {
        post.titleAndBodyAttributedText = PostTitleAndBodyView.buildText(post)
        for (commentIndex, _) in post.latestComments.enumerated() {
            var comment = post.latestComments[commentIndex]
            comment.bodyAttributedText = CommentBodyView.buildBodyText(comment)
            post.latestComments[commentIndex] = comment
        }
    }
}
