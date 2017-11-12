//
//  DashboardController.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 8. 20..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import LBTAComponents

class DashboardController: DatasourceController, DashboardDatasourceDelegate, PostRefetchableController, PostActionBarDelegate, CommentsControllerDelegate, LatestCommentsViewDelegate {
    //TODO: errorMessageLabel
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionViewLayout.invalidateLayout()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
        navigationItem.title = "내 피드"
        setupLogOutButton()
        self.datasource = DashboardDatasource(controller: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == DashboardDatasource.POST_SECTION {
            guard let post = self.datasource?.item(indexPath) as? Post else { return .zero }
            return CGSize(width: view.frame.width, height: PostCell.height(post, frame: view.frame))
        } else if indexPath.section == DashboardDatasource.BOTTOM_INDICATOR_SECTION {
            return CGSize(width: view.frame.width, height: 50)
        }
        
        return super.collectionView(collectionView, layout: collectionViewLayout, sizeForItemAt: indexPath)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 무한스크롤 - 다음페이지 로딩
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        
        if offsetY > contentHeight - scrollView.frame.size.height {
            guard let datasource = datasource as? DashboardDatasource else { return }
            datasource.fetchPosts()
        }
    }
    
    // MARK: DashboardDatasourceDelegate 구현
    
    func reloadData() {
        collectionView?.reloadData()
        collectionView?.backgroundColor = UIColor.app_light_gray
    }
    
    func reloadItem(at indexPath: IndexPath) {
        collectionView?.reloadItems(at: [indexPath])
    }
    
    // MARK: PostRefetchableController 구현
    
    func refetch(post: Post) {
        guard let datasource = datasource as? DashboardDatasource else { return }
        datasource.fetch(post: post)
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
        guard let datasource = datasource as? DashboardDatasource else { return }
        datasource.reloadItem(post: post)
    }
    
    // MARK: LatestCommentsViewDelegate 구현
    
    func didTapMoreComments(post: Post) {
        let commentsController = CommentsController()
        commentsController.post = post
        commentsController.delegate = self
        commentsController.needToShowKeyboardOnViewDidAppear = false
        navigationController?.pushViewController(commentsController, animated: true)
    }
    
    // 로그아웃 - 시작
    
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
    
    // 로그아웃 - 끝
}
