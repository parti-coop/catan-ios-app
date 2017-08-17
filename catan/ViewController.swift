//
//  ViewController.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 15..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import LBTAComponents
import FacebookLogin

class ViewController: UIViewController {
    let logo: UIImageView = {
        let logo = UIImageView()
        logo.image = #imageLiteral(resourceName: "login_logo").withRenderingMode(.alwaysOriginal)
        return logo
    }()
    
    let facebookSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("페이스북으로 로그인", for: .normal)
        button.layer.cornerRadius = Style.DEFAULT_RADIOUS
        button.titleLabel?.font = Style.DEFAULT_BOLD_FONT
        button.setTitleColor(.white, for: .normal)

        button.backgroundColor = UIColor(r: 59, g: 89, b: 152)
        button.setImage(#imageLiteral(resourceName: "facebook_sm").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        
        button.addTarget(self, action: #selector(handleFacebookSignIn), for: .touchUpInside)
        return button
    }()
    
    let twitterSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("트위터로 로그인", for: .normal)
        button.layer.cornerRadius = Style.DEFAULT_RADIOUS
        button.titleLabel?.font = Style.DEFAULT_BOLD_FONT
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = UIColor(r: 0, g: 172, b: 237)
        button.setImage(#imageLiteral(resourceName: "twitter_sm").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        return button
    }()
    
    let googleSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("구글로 로그인", for: .normal)
        button.layer.cornerRadius = Style.DEFAULT_RADIOUS
        button.titleLabel?.font = Style.DEFAULT_BOLD_FONT
        button.setTitleColor(.white, for: .normal)

        button.backgroundColor = UIColor(r: 211, g: 72, b: 54)
        button.setImage(#imageLiteral(resourceName: "google_sm").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        return button
    }()
    
    let emailSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("이메일로 로그인", for: .normal)
        button.layer.cornerRadius = Style.DEFAULT_RADIOUS
        button.titleLabel?.font = Style.DEFAULT_BOLD_FONT
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = UIColor(r: 43, g: 196, b: 138)
        button.setImage(#imageLiteral(resourceName: "email_sm").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.BRAND_PRIMARY
        view.addSubview(logo)
        logo.anchor(view.topAnchor, topConstant: 100)
        logo.anchorCenterXToSuperview()
        
        setupSignInButtons()
    }
    
    fileprivate func setupSignInButtons() {
        let stackView = UIStackView(arrangedSubviews: [facebookSignInButton, twitterSignInButton, googleSignInButton, emailSignInButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.anchor(logo.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topConstant: 40, leftConstant: 40, rightConstant: 40, heightConstant: 200)
    }
    
    func handleFacebookSignIn() {
        let loginManager = LoginManager()
        loginManager.logOut()
        loginManager.logIn([.publicProfile], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                print(error)
            case .cancelled:
                print("User cancelled login.")
            case .success(_, _, let accessToken):
                Service.sharedInstance.auth(facebookAccessToken: accessToken.authenticationToken, withSuccess: {
                    print("로그인 성공")
                }, failure: { (err) in
                    print("로그인 실패", err)
                })
            }
        }
    }
}

