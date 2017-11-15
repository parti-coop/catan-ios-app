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
            
            if let _ = error {
                log.error("앱의 회원 정보가 없거나 해당 회원이 탈퇴한 상태입니다. 다시 로그인해야 합니다.")
                self.showLoginView()
            }
            self.setupViewController()
        }
    }
    
    fileprivate func showLoginView() {
        DispatchQueue.main.async {
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
