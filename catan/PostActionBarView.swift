//
//  PostActionBarView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 10. 31..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import BonMot

class PostActionBarView: UIView {
    var forceWidth = CGFloat(0) {
        didSet {
            if post != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
        }
    }

    let upvoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("공감해요", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handleUpvote), for: .touchUpInside)
        return button
    }()

    let commentingButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("댓글달기", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(handleCommenting), for: .touchUpInside)
        return button
    }()

    func handleUpvote() {
        print("click upvote")
    }
    
    func handleCommenting() {
        print("click comment")
    }

    let upvoteLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    var post: Post? {
        didSet {
            guard let post = post else { return }
            upvoteLabel.attributedText = buildUpvoteLabelText(post)
        }
    }

    fileprivate func buildUpvoteLabelText(_ post: Post) -> NSAttributedString? {
        if post.upvotesCount <= 0 { return nil }

        let color = (post.isUpvotedByMe ? UIColor.brand_primary : UIColor.gray)
        let heartImage = #imageLiteral(resourceName: "hearts_filled").withRenderingMode(.alwaysTemplate).tintedImage(color: color)

        return NSAttributedString.composed(of: [
            heartImage.styled(with: .baselineOffset(-2)),
            Special.noBreakSpace,
            String(post.upvotesCount).styled(with: Style.string.defaultSmall, .color(color))
            ])
    }

    init() {
        super.init(frame: .zero)
        setupViews()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews() {
        addSubview(upvoteButton)
        addSubview(commentingButton)
        addSubview(upvoteLabel)

        let margin = Style.dimension.defaultSpace

        upvoteButton.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil,
                            topConstant: margin, leftConstant: Style.dimension.postCell.paddingLeft, bottomConstant: 0, rightConstant: 0,
                            heightConstant: Style.dimension.defautLineHeight)
        commentingButton.anchor(topAnchor, left: upvoteButton.rightAnchor, bottom: nil, right: nil,
                                topConstant: margin, leftConstant: Style.dimension.largeSpace, bottomConstant: 0, rightConstant: 0,
                                heightConstant: Style.dimension.defautLineHeight)
        upvoteLabel.anchor(topAnchor, left: commentingButton.rightAnchor, bottom: nil, right: nil,
                           topConstant: margin, leftConstant: Style.dimension.largeSpace, bottomConstant: 0, rightConstant: 0,
                           widthConstant: 0, heightConstant: Style.dimension.defautLineHeight)
    }

    override var intrinsicContentSize: CGSize {
        if post == nil {
            return super.intrinsicContentSize
        }

        return CGSize(width: forceWidth, height: PostActionBarView.estimateHeight())
    }

    static func estimateHeight() -> CGFloat {
        return Style.dimension.defaultDividerHeight
            + Style.dimension.defaultSpace
            + Style.dimension.defautLineHeight
            + Style.dimension.defaultSpace
    }
}
