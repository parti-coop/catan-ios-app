//
//  DashboardController.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 20..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class DashboardController: UICollectionViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        navigationItem.title = "내 피드 @\(UserSession.sharedInstance.user?.nickname)"
        
        setupLogOutButton()
    }
    
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
}
