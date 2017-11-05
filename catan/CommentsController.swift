//
//  CommentsController.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 11. 5..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import LBTAComponents

class CommentsController: DatasourceController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .red
        
//        navigationItem.title = "내 피드"
//        setupLogOutButton()
//        self.datasource = DashboardDatasource(controller: self)
    }
}
