//
//  PostDatasource.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 23..
//  Copyright © 2017년 Parti. All rights reserved.
//

import LBTAComponents
import TRON

class DashboardDatasource: Datasource {
    override init() {
        super.init()
    }
    
    override func cellClasses() -> [DatasourceCell.Type] {
        return [PostCell.self]
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        return 5
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        return "Post"
    }
}
