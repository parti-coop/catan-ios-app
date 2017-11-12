//
//  CommentsController.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 11. 5..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import LBTAComponents

protocol CommentsControllerDelegate {
    func needToUpdateComments(of: Post)
}

class CommentsController: DatasourceController, UIGestureRecognizerDelegate, CommentsDatasourceDelegate, CommentFormViewDelegate {
    var post: Post? {
        didSet {
            guard let post = post else { return }
            self.datasource = CommentsDatasource(controller: self, post: post)
        }
    }
    var delegate: CommentsControllerDelegate?
    var hideLoadingFooter: Bool = true
    var hideLoadingHeader: Bool = true
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        
        if let datasource = self.datasource as? CommentsDatasource {
            datasource.leaveOnlyLastPageComments()
        }
        
        if let delegate = delegate, let post = post {
            delegate.needToUpdateComments(of: post)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let datasource = self.datasource as? CommentsDatasource else { return }
        
        datasource.firstFetchComments()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        navigationItem.title = "댓글"
        commentFormView.delegate = self
    }
    
    // MARK: 각 셀의 크기 설정 및 DatasourceController 확장
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let comment = self.datasource?.item(indexPath) as? Comment else { return .zero }
        return CGSize(width: view.frame.width, height: CommentCell.height(comment, frame: view.frame))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if hideLoadingFooter {
            return CGSize.zero
        } else {
            return CGSize(width: view.frame.width, height: 50)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if hideLoadingHeader {
            return CGSize.zero
        } else {
            return CGSize(width: view.frame.width, height: 50)
        }
    }
    
    // MARK: UIGestureRecognizerDelegate 구현
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: CommentsDatasourceDelegate 구현
    
    func reloadData(isScrollToBottom: Bool) {
        self.hideLoadingHeader = true
        self.hideLoadingFooter = true
        collectionView?.reloadData()
        if isScrollToBottom {
            scrollToBottom(animated: false)
        }
    }
    
    func scrollToBottom(animated: Bool) {
        guard let datasource = self.datasource as? CommentsDatasource else { return }
        collectionView?.scrollToItem(at: datasource.lastIndex(), at: .bottom, animated: animated)
    }
    
    // MARK: CommentFormViewDelegate 구현
    
    func handleCommentSubmit(body: String) {
        guard let datasource = self.datasource as? CommentsDatasource else { return }
        
        showLoadingFooter()
        scrollToBottom(animated: true)
        datasource.createComment(body: body)
    }

    // MARK: 하단 입력폼

    let commentFormView: CommentFormView = {
        let view = CommentFormView()
        return view
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return commentFormView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        commentFormView.handleSubmit()
        return true
    }
    
    // MARK: 로딩 인디케이터
    
    func showLoadingHeader() {
        self.hideLoadingHeader = false
        collectionView?.reloadData()
    }
    
    func showLoadingFooter() {
        self.hideLoadingFooter = false
        collectionView?.reloadData()
    }
}
