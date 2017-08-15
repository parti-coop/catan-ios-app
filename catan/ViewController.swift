//
//  ViewController.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 15..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import LBTAComponents

class ViewController: UIViewController {
    let logo: UIImageView = {
        let logo = UIImageView()
        logo.image = #imageLiteral(resourceName: "login_logo").withRenderingMode(.alwaysOriginal)
        return logo
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.BRAND_PRIMARY
        view.addSubview(logo)
        logo.anchor(view.topAnchor, topConstant: 100)
        logo.anchorCenterXToSuperview()
    }
}

