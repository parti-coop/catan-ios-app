//
//  MainTabBarController.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 18..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !UserSession.sharedInstance.isLogin() {
            showLoginView()
            return
        }
        
        //TODO: 로딩화면 보이기
        
        UserSession.sharedInstance.cacheUser { user, error in
            // TODO: 로딩화면 닫기
            
            if let error = error {
                //TODO: 로그인 정보에 해당하는 사용자가 없는 경우 혹은 네트워크 오류
                log.error("다시 로그인해야 합니다. \(error)")
                self.showLoginView()
            }
            self.setupViewController()
        }
    }
    
    fileprivate func showLoginView() {
        DispatchQueue.main.async {
            if let currentDispatch = OperationQueue.current?.underlyingQueue {
                print(currentDispatch)
            }
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func setupViewController() {
        // TODO: LBTA라이브러를 이용하자
        let layout = UICollectionViewFlowLayout()
        let dashboardController = DashboardController(collectionViewLayout: layout)
        let navController = UINavigationController(rootViewController: dashboardController)
        
        navController.tabBarItem.image = #imageLiteral(resourceName: "dashboard_menu")
        navController.tabBarItem.selectedImage = #imageLiteral(resourceName: "dashboard_menu_filled")
        
        tabBar.tintColor = .black
        
        viewControllers = [navController, UIViewController()]
    }
}
