//
//  UIAlertController.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 11. 15..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func alertError(message: String? = "죄송합니다. 뭔가 잘못되었습니다.", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(
            title: "오류",
            message: message,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(
            title: "확인",
            style: .default)
        
        alert.addAction(okAction)
        alert.presentInOwnWindow(animated: true, completion: completion)
    }
    
    fileprivate func presentInOwnWindow(animated: Bool, completion: (() -> Void)?) {
        let alertWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = UIWindowLevelAlert + 1;
        alertWindow.makeKeyAndVisible()
        alertWindow.rootViewController?.present(self, animated: animated, completion: completion)
    }
}
