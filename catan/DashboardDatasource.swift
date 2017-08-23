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

class DashboardDatasource: Datasource {
    var posts = [Post]()
    var isFinishedPagination = false
    weak var controller: DatasourceController?

    init(controller: DatasourceController) {
        self.controller = controller
        super.init()
        fetchPosts()
    }
    
    override func cellClasses() -> [DatasourceCell.Type] {
        return [PostCell.self]
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        return posts.count
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        if (posts.count - 1 == indexPath.item) && !isFinishedPagination {
            fetchPosts()
        }
        
        return posts[indexPath.item]
    }
    
    fileprivate func fetchPosts() {
        let lastPostId = posts.last?.id
        PostRequestFactory.fetchPageOnDashBoard(lastPostId: lastPostId).resume { (page, error) in
            if let error = error {
                // TODO: 일반 오류인지, 네트워크 오류인지 처리 필요
                log.error("게시글 로딩 실패 : \(error.localizedDescription)")
                self.isFinishedPagination = true
                return
            }
            
            guard let page = page else { return }
            self.posts += page.items
            self.isFinishedPagination = !page.hasMoreItem
            
            self.controller?.collectionView?.reloadData()
        }
    }
    
    // 게시글 가져오기 - 끝
}
