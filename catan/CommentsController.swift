//
//  CommentsController.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 11. 5..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import LBTAComponents

class CommentsController: DatasourceController, UIGestureRecognizerDelegate, CommentsDatasourceDelegate {
    var post: Post?
    
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        navigationItem.title = "댓글"
        if let post = post {
            self.datasource = CommentsDatasource(controller: self, post: post)
        }
    }
    
    // MARK: UIGestureRecognizerDelegate 구현
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: CommentsDatasourceDelegate 구현
    
    func reloadData() {
        collectionView?.reloadData()
//        collectionView?.backgroundColor = UIColor.app_light_gray
    }

    lazy var containerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
        
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("저장", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        containerView.addSubview(submitButton)
        submitButton.anchor(containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 0)
        
        containerView.addSubview(self.commentTextField)
        self.commentTextField.anchor(containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: submitButton.leftAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        return containerView
    }()
    
    let commentTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "댓글을 입력하세요"
        return textField
    }()
    
    func handleSubmit() {
        guard let post = post, let body = commentTextField.text else { return }
        CommentRequestFactory.post(postId: post.id, body: body).resume { [weak self] (response, error) in
//            guard let strongSelf = self, let poll = strongSelf.post?.poll else { return }
//            if let _ = error {
//                // TODO: 일반 오류인지, 네트워크 오류인지 처리 필요
//                return
//            }
//
//            poll.vote(choice, by: user)
//            strongSelf.setupVoteButtons(poll: poll)
//            strongSelf.setupVoteUsers(poll: poll)
        }
    }
    
    override var inputAccessoryView: UIView? {
        get {
            return containerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
