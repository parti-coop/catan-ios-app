//
//  PostDocumentFileSourcesView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 4..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import BonMot
import UICircularProgressRing
import TRON
import Alamofire

class PostDocumentFileSourceView: UIView, FileSourceDownloadDelegate {
    static let forceHeight = Style.dimension.postCell.downloadButtonSize
    
    var documentInteractionController: UIDocumentInteractionController?
    
    var forceWidth = CGFloat(0)
    let post: Post
    let fileSource: FileSource
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = Style.font.defaultNormal
        label.numberOfLines = 1
        return label
    }()
    
    let sizeLabel: UILabel = {
        let label = UILabel()
        label.font = Style.font.smallNormal
        label.textColor = .app_gray
        label.numberOfLines = 1
        return label
    }()
    
    let downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(handleDownload), for: .touchUpInside)
        return button
    }()
    
    let downloadPauseMark: UIView = {
        let view = UIView()
        view.backgroundColor = .app_gray
        return view
    }()
    
    let downloadProgressRing: UICircularProgressRingView = {
        let progressRing = UICircularProgressRingView(frame: CGRect(x: 0, y: 0, width: 240, height: 240))
        progressRing.maxValue = 100
        progressRing.outerRingWidth = 1
        progressRing.innerRingWidth = 3
        progressRing.innerRingColor = .app_gray
        progressRing.outerRingColor = .app_gray
        progressRing.shouldShowValueText = false
        progressRing.isUserInteractionEnabled = false
        return progressRing
    }()
    
    let downloadControlContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    func fileSourceDownloadOnReady() {
        setupDownloadButtonImageAsReady()
        downloadProgressRing.isHidden = true
    }
    
    func fileSourceDownloadOnRunning(progress: Progress?) {
        downloadButton.setImage(nil, for: .normal)
        downloadProgressRing.isHidden = false
        if let progress = progress {
            downloadProgressRing.setProgress(value: caculateProgressValue(progress), animationDuration: 0)
        }
    }
    
    func fileSourceDownloadOnPause() {
        setupDownloadButtonImageAsReady()
        downloadProgressRing.isHidden = true
    }
    
    func fileSourceDownloadOnCompleted() {
        setupDownloadButtonImageAsCompleted()
        downloadProgressRing.isHidden = true
    }
    
    func openFileSourceDownloaded() {
        setupDocumentInteractionController(fileSource.downloadDestinationURL())
        documentInteractionController?.presentOptionsMenu(from: CGRect.zero, in: self, animated: true)
    }
    
    func fileSourceDownloadProgress(_ progress: Progress) {
        downloadProgressRing.setProgress(value: caculateProgressValue(progress), animationDuration: 5)
    }
    
    fileprivate func caculateProgressValue(_ progress: Progress) -> CGFloat {
        return downloadProgressRing.maxValue * CGFloat(progress.fractionCompleted)
    }
    
    fileprivate func setupDocumentInteractionController(_ destinationURL: URL) {
        if documentInteractionController == nil {
            documentInteractionController = UIDocumentInteractionController(url: destinationURL)
        }
    }
    
    public init(post: Post, fileSource: FileSource, forceWidth: CGFloat) {
        self.post = post
        self.fileSource = fileSource
        self.forceWidth = forceWidth
        super.init(frame: .zero)
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(handleDownload))
        addGestureRecognizer(tap)
        setupViews()
    }
    
    func handleDownload() {
        fileSource.handleDownloadFile()
    }
    
    fileprivate func setupViews() {
        layer.borderWidth = 1;
        layer.borderColor = UIColor.app_light_gray.cgColor
        layer.cornerRadius = Style.dimension.defaultRadius
        layer.masksToBounds = true
        
        setupDownloadControlViews()
        setupLabels()
        
        fileSource.fileSourceDownloadDelegate = self
    }
    
    fileprivate func setupDownloadControlViews() {
        addSubview(downloadButton)
        downloadButton.anchor(right: rightAnchor,
                              rightConstant: Style.dimension.defaultSpace,
                              widthConstant: Style.dimension.postCell.downloadButtonSize,
                              heightConstant: Style.dimension.postCell.downloadButtonSize)
        downloadButton.anchorCenterYToSuperview()
        
        downloadButton.addSubview(downloadProgressRing)
        downloadProgressRing.anchorCenterSuperview()
        downloadProgressRing.anchor(widthConstant: Style.dimension.postCell.downloadProgressRingSize, heightConstant: Style.dimension.postCell.downloadProgressRingSize)
    
        downloadProgressRing.addSubview(downloadPauseMark)
        downloadPauseMark.anchor(widthConstant: Style.dimension.postCell.downloadProgressRingSize / 3, heightConstant: Style.dimension.postCell.downloadProgressRingSize / 3)
        downloadPauseMark.anchorCenterSuperview()
    }
    
    fileprivate func setupDownloadButtonImageAsReady() {
        downloadButton.setImage(#imageLiteral(resourceName: "download").withRenderingMode(.alwaysOriginal).tintedImage(color: UIColor.app_gray), for: .normal)
    }
    
    fileprivate func setupDownloadButtonImageAsCompleted() {
        downloadButton.setImage(#imageLiteral(resourceName: "view_file").withRenderingMode(.alwaysOriginal).tintedImage(color: UIColor.app_gray), for: .normal)
    }
    
    fileprivate func setupLabels() {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        addSubview(stackView)
        
        stackView.anchor(left: leftAnchor, right: downloadButton.leftAnchor,
                         leftConstant: Style.dimension.defaultSpace, rightConstant: Style.dimension.defaultSpace)
        stackView.anchorCenterYToSuperview()
        
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(sizeLabel)
        
        nameLabel.text = fileSource.name
        sizeLabel.text = fileSource.humanFileSize
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: forceWidth, height: PostDocumentFileSourceView.forceHeight)
    }
}

class PostDocumentFileSourcesView: UIStackView {
    var forceWidth = CGFloat(0) {
        didSet {
            if post != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
            
            for view in arrangedSubviews {
                guard let rowView = view as? PostDocumentFileSourceView else { continue }
                rowView.forceWidth = forceWidth
            }
        }
    }
    
    var post: Post? {
        didSet {
            removeAllArrangedSubview()
            
            if let post = post {
                let fileSourcesOnlyDocument = post.fileSourcesOnlyDocument()
                for fileSource in fileSourcesOnlyDocument {
                    let subview = buildDocumentRow(post: post, fileSource: fileSource)
                    addArrangedSubview(subview)
                }
            }
            setNeedsLayout()
        }
    }
    
    fileprivate func removeAllArrangedSubview() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
    }
    
    fileprivate func buildDocumentRow(post: Post, fileSource: FileSource) -> PostDocumentFileSourceView {
        return PostDocumentFileSourceView(post: post, fileSource: fileSource, forceWidth: forceWidth)
    }
    
    init() {
        super.init(frame: .zero)
        axis = .vertical
        distribution = .equalSpacing
        spacing = Style.dimension.postCell.documentFileSourceSpace
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: 0, left: Style.dimension.postCell.paddingLeft, bottom: 0, right: Style.dimension.postCell.paddingRight)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func visible() -> Bool {
        return !arrangedSubviews.isEmpty
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        guard let post = post else { return CGFloat(0) }
        
        let fileSourcesOnlyDocument = post.fileSourcesOnlyDocument()
        let rowCount = post.fileSourcesOnlyDocument().count
        let rowsSpace = CGFloat(max(0, rowCount - 1)) * Style.dimension.postCell.documentFileSourceSpace
        
        return (CGFloat(fileSourcesOnlyDocument.count) * PostDocumentFileSourceView.forceHeight) + rowsSpace
    }
}
