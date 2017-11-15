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
    func reloadItem(at: IndexPath)
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
            if posts.count < indexPath.item {
                return nil
            }
            return posts[indexPath.item]
        }
        
        return super.item(indexPath)
    }
    
    func emptyPosts() {
        self.posts.removeAll()
    }
    
    func fetchPosts() {
        if self.isLoadingMore {
            return
        }
        self.isLoadingMore = true
       
        let lastPostId = posts.last?.id
        PostRequestFactory.fetchPageOnDashBoard(lastPostId: lastPostId).perform(
            with: { [weak self] (page, error) in
                guard let strongSelf = self else { return }
                
                if let _ = error {
                    strongSelf.isFinishedPagination = true
                    UIAlertController.alertError()
                    return
                }
                
                guard let page = page else { return }
                for post in page.items {
                    strongSelf.setupTexts(post: post)
                }
                strongSelf.posts += page.items
                strongSelf.isFinishedPagination = !page.hasMoreItem
            }, finally: { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.isLoadingMore = false
                strongSelf.controller?.reloadData()
        })
    }
    
    func fetch(post: Post) {
        PostRequestFactory.fetch(postId: post.id).perform(
            withSuccess: { [weak self] (reloadedPost) in
                guard let strongSelf = self else { return }
                
                guard let index = strongSelf.posts.index(where: { (post) -> Bool in
                    post.id == reloadedPost.id
                }) else { return }
                
                strongSelf.setupTexts(post: reloadedPost)
                strongSelf.posts[index] = reloadedPost
                
                strongSelf.controller?.reloadData()
        })
    }
    
    func reloadItem(post: Post) {
        guard let index = (posts.index { (element) -> Bool in
            return element.id == post.id
        }) else { return }
        controller?.reloadItem(at: IndexPath(item: index, section: DashboardDatasource.POST_SECTION))
    }
    
    func setupTexts(post: Post) {
        post.titleAndBodyAttributedText = PostTitleAndBodyView.buildText(post)
        for comment in post.bufferComments {
            comment.bodyAttributedText = CommentBodyView.buildBodyText(comment)
        }
    }
}
