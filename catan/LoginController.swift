//
//  LoginController.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 20..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import LBTAComponents
import FacebookLogin
import FacebookCore
import BonMot

class LoginController: UIViewController {
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        
        let attributedTitle = "빠띠에 가입하지 않으셨나요? <em>가입하기</em>".styled(
            with: Style.string.defaultNormal, .color(.app_light_gray),
            .xmlRules([
                .style("em", StringStyle(.color(.white), Style.string.defaultBold))
            ]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    @objc func handleShowSignUp() {
        //TODO: 가입하기
    }
    
    let logo: UIImageView = {
        let logo = UIImageView()
        logo.image = #imageLiteral(resourceName: "login_logo").withRenderingMode(.alwaysOriginal)
        return logo
    }()
    
    let facebookSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("페이스북으로 로그인", for: .normal)
        button.layer.cornerRadius = Style.dimension.defaultRadius
        button.titleLabel?.font = Style.font.defaultBold
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
        button.layer.cornerRadius = Style.dimension.defaultRadius
        button.titleLabel?.font = Style.font.defaultBold
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = UIColor(r: 0, g: 172, b: 237)
        button.setImage(#imageLiteral(resourceName: "twitter_sm").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        return button
    }()
    
    let googleSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("구글로 로그인", for: .normal)
        button.layer.cornerRadius = Style.dimension.defaultRadius
        button.titleLabel?.font = Style.font.defaultBold
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = UIColor(r: 211, g: 72, b: 54)
        button.setImage(#imageLiteral(resourceName: "google_sm").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        return button
    }()
    
    let emailSignInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("이메일로 로그인", for: .normal)
        button.layer.cornerRadius = Style.dimension.defaultRadius
        button.titleLabel?.font = Style.font.defaultBold
        button.setTitleColor(.white, for: .normal)
        
        button.backgroundColor = UIColor(r: 43, g: 196, b: 138)
        button.setImage(#imageLiteral(resourceName: "email_sm").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
        return button
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.brand_primary
        navigationController?.isNavigationBarHidden = true
        
        setupLogo()
        setupSignInButtons()
        setupSignUpButton()
    }
    
    fileprivate func setupLogo() {
        view.addSubview(logo)
        logo.anchor(view.topAnchor, topConstant: 100)
        logo.anchorCenterXToSuperview()
    }
    
    fileprivate func setupSignInButtons() {
        let stackView = UIStackView(arrangedSubviews: [facebookSignInButton, twitterSignInButton, googleSignInButton, emailSignInButton])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.anchor(logo.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, topConstant: 100, leftConstant: 40, rightConstant: 40, heightConstant: 200)
    }
    
    @objc func handleFacebookSignIn() {
        let loginManager = LoginManager()
        if let _ = AccessToken.current {
           loginManager.logOut()
        }
        loginManager.logIn(readPermissions: [.publicProfile], viewController: self) { (loginResult) in
            switch loginResult {
            case .failed(let error):
                UIAlertController.alertError()
                log.error("로그인 실패 :", error.localizedDescription)
            case .cancelled:
                UIAlertController.alertInfo(message: "로그인을 취소하였습니다.")
                log.debug("로그인 취소")
            case .success(_, _, let accessToken):
                Service.sharedInstance.auth(facebookAccessToken: accessToken.authenticationToken, withSuccess: {
                    self.handleSignIn()
                }, failure: { (error) in
                    UIAlertController.alertError()
                    log.error("로그인 실패 :", error.localizedDescription)
                })
            }
        }
    }
    
    fileprivate func handleSignIn() {
        UserSession.sharedInstance.cacheUser { (user, error) in
            if let _ = error {
                UIAlertController.alertInfo(message: "회원으로 가입되어 있지 않습니다. 먼저 회원가입을 해주세요.")
                return
            }
                        
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
            mainTabBarController.setupViewController()
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func setupSignUpButton() {
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
    }
}
