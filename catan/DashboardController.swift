//
//  DashboardController.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 20..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import LBTAComponents

class DashboardController: DatasourceController {
    //TODO: errorMessageLabel
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.app_lighter_gray
        
        navigationItem.title = "내 피드"
        setupLogOutButton()
        
        fetchPosts()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    
    // 게시글 가져오기 - 시작
    
    fileprivate func fetchPosts() {
        let postDataSource = DashboardDatasource()
        self.datasource = postDataSource
    }
    
    // 게시글 가져오기 - 끝

    // 로그아웃 - 시작
    
    fileprivate func setupLogOutButton() {
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "settings_filled"), style: .plain, target: self, action: #selector(handleLogOut))
    }

    func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alertController.addAction(UIAlertAction(title: "로그아웃", style: .destructive, handler: { (_) in
            UserSession.sharedInstance.logOut()
            
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            self.present(navController, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    // 로그아웃 - 끝
}
