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
        
        //TODO: 로딩화면 보이기
        view.backgroundColor = .white

        if !UserSession.sharedInstance.isLogin() {
            showLoginView()
            return
        }
        
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
            //TODO: 삭제필요
            if let currentDispatch = OperationQueue.current?.underlyingQueue {
                print(currentDispatch)
            }
            let loginController = LoginController()
            let navController = UINavigationController(rootViewController: loginController)
            self.present(navController, animated: true, completion: nil)
        }
    }
    
    func setupViewController() {
        let dashboardController = DashboardController()
        let dashboardNavController = templateNavController(rootViewController: dashboardController, unselectedImage: #imageLiteral(resourceName: "dashboard_menu"), selectedImage: #imageLiteral(resourceName: "dashboard_menu_filled"))
        
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_menu"), selectedImage: #imageLiteral(resourceName: "search_menu_filled"))
        
        let plusNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_menu"), selectedImage: #imageLiteral(resourceName: "plus_menu_filled"))
        
        let messagesController = templateNavController(unselectedImage: #imageLiteral(resourceName: "messages_menu"), selectedImage: #imageLiteral(resourceName: "messages_menu_filled"))
        
        let moreController = templateNavController(unselectedImage: #imageLiteral(resourceName: "more_menu"), selectedImage: #imageLiteral(resourceName: "more_menu_filled"))
        
        
        tabBar.tintColor = .black
        
        viewControllers = [
            dashboardNavController,
            searchNavController,
            plusNavController,
            messagesController,
            moreController]
        
        //tab bar item insets 수정
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    func templateNavController(rootViewController: UIViewController = UIViewController(), unselectedImage: UIImage, selectedImage: UIImage) -> UIViewController {
        let navController = UINavigationController(rootViewController: rootViewController)
        
        navController.tabBarItem.image = unselectedImage
        navController.tabBarItem.selectedImage = selectedImage

        return navController
    }
}
