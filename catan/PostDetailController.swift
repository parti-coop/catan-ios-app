//
//  PostDetailController.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 11. 20..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import LBTAComponents

protocol PostDetailControllerDelegate: class {
    func needToUpdate(of: Post)
}

class PostDetailController: UIViewController, PostDetailDatasourceDelegate, PostViewDelegate, PostActionBarDelegate, CommentsControllerDelegate, LatestCommentsViewDelegate, CommentViewDelegate {
    
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceHorizontal = false
        scrollView.backgroundColor = .clear
        scrollView.alwaysBounceVertical = true
        return scrollView
    }()
    var postView = PostView()

    weak var delegate: PostDetailControllerDelegate?
    var datasource: PostDetailDatasource?
    var post: Post? {
        didSet {
            guard let post = post else { return }
            postId = post.id
            postView.post = post
            postView.delegate = self
            
            let height = PostView.height(post, width: view.frame.width)
            scrollView.contentSize = CGSize(width: view.frame.width, height: height)
            postView.anchor(heightConstant: height)
            
            view.setNeedsLayout()
        }
    }
    var postId: Int? {
        didSet {
            guard let postId = postId else { return }
            if datasource == nil {
                datasource = PostDetailDatasource(controller: self, postId: postId)
            }
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view.setNeedsLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        
        if let post = datasource?.post {
            delegate?.needToUpdate(of: post)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        scrollView.fillSuperview()
        
        navigationItem.title = "게시글"
        
        datasource?.loadData()
    }
    
    // MARK: PostDetailDatasourceDelegate 구현
    
    func setupViews() {
        view.backgroundColor = .app_light_gray
        postView.setupViews(width: view.frame.width)
        scrollView.addSubview(postView)
        postView.anchor(scrollView.topAnchor, left: scrollView.leftAnchor, topConstant: 0, leftConstant: 0,
                        widthConstant: view.frame.width)
        postView.isHidden = true
    }
    
    func onLoadPost(post: Post) {
        navigationItem.title = post.specificDescStripedTags
        self.post = post
        postView.isHidden = false
    }
    
    // MARK: PostActionBarDelegate 구현
    
    func didTapAddingComment(post: Post) {
        let commentsController = CommentsController()
        commentsController.post = post
        commentsController.delegate = self
        commentsController.needToShowKeyboardOnViewDidAppear = true
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    // MARK: CommentsControllerDelegate 구현
    
    func needToUpdateComments(of post: Post) {
        self.post = post
    }
    
    // MARK: LatestCommentsViewDelegate 구현
    
    func didTapMoreComments(post: Post) {
        let commentsController = CommentsController()
        commentsController.post = post
        commentsController.delegate = self
        commentsController.needToShowKeyboardOnViewDidAppear = false
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    // MARK: CommentViewDelegate 구현
    
    func didTapAddingComment(post: Post, toComment: Comment?) {
        let commentsController = CommentsController()
        commentsController.post = post
        commentsController.toComment = toComment
        commentsController.delegate = self
        commentsController.needToShowKeyboardOnViewDidAppear = true
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    // MARK: PostViewDelegate 구현
    
    func refetch(post: Post) {
        self.post = post
    }
    
    func didTapDetail(post: Post) {
        
    }
}

