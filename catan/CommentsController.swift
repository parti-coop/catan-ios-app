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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .red
    }
}
