//
//  ContentSizePreservingFlowLayout.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 11. 13..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

class ContentSizePreservedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    var beforeContentSize: CGSize?
    var keeingBeforeContentSize = false {
        didSet {
            if keeingBeforeContentSize {
                beforeContentSize = collectionViewContentSize
            } else {
                beforeContentSize = nil
            }
        }
    }
    
    func maintainScrollPosition() {
        guard let beforeContentSize = beforeContentSize, let collectionView = collectionView else { return }
        let afterContentSize = collectionViewContentSize
        let diff = afterContentSize.height - beforeContentSize.height
        collectionView.contentOffset = CGPoint(
            x: collectionView.contentOffset.x,
            y: collectionView.contentOffset.y + diff
        )
    }
}
