//
//  LatestCommentsView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 26..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class LatestCommentsView: UIView {
    static let heightCache = HeightCache()
  
    var post: Post? {
        didSet {
            //guard let post = post else { return }
        
            collapse(out: estimateHeight(width: frame.width))
        }
    }
    
    public init() {
        super.init(frame: .zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func estimateHeight(width: CGFloat) -> CGFloat {
        guard let post = post else { return 0 }
        if post.hasNoComments() { return 0 }
        
        return 200
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        let dummyView = LatestCommentsView()
        dummyView.post = post
        
        return dummyView.estimateHeight(width: width)
    }
}
