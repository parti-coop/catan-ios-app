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
            return isLoadingMore ? 1 : 0
        }
        
        return super.numberOfItems(section)
    }
    
    override func numberOfSections() -> Int {
        return 2
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        if indexPath.section == DashboardDatasource.POST_SECTION {
            if (posts.count - 1 == indexPath.item) && !isFinishedPagination {
                self.isLoadingMore = true
                self.controller?.reloadData()
                
                fetchPosts()
            }
            
            return posts[indexPath.item]
        }
        
        return super.item(indexPath)
    }
    
    fileprivate func fetchPosts() {
        let lastPostId = posts.last?.id
        PostRequestFactory.fetchPageOnDashBoard(lastPostId: lastPostId).resume { (page, error) in
            self.isLoadingMore = true

            if let error = error {
                // TODO: 일반 오류인지, 네트워크 오류인지 처리 필요
                log.error("게시글 로딩 실패 : \(error.localizedDescription)")
                self.isFinishedPagination = true
                self.controller?.reloadData()
                return
            }
            
            guard let page = page else { return }
            self.posts += page.items
            self.isFinishedPagination = !page.hasMoreItem
            
            self.controller?.reloadData()
        }
    }
}
