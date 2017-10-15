//
//  PollView.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 9. 7..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit
import BonMot
import KRWordWrapLabel

class PollView: UIView {
    static let prototype = PollView()
    
    let titleLabel: KRWordWrapLabel = {
        let label = KRWordWrapLabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = Style.font.largeThin
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let agreeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = Style.dimension.defaultRadius
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleAgree), for: .touchUpInside)
        return button
    }()

    func handleAgree() {
        guard let poll = post?.poll else { return }
        let choice = poll.isAgreed() ? "unsure" : "agree"
        handleVote(poll: poll, choice: choice)
    }
    
    let disagreeButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = Style.dimension.defaultRadius
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(handleDisagree), for: .touchUpInside)
        return button
    }()
    
    func handleDisagree() {
        guard let poll = post?.poll else { return }
        let choice = poll.isDisagreed() ? "unsure" : "disagree"
        handleVote(poll: poll, choice: choice)
    }
    
    let agreeVoteUsers: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        view.axis = .horizontal
        view.spacing = Style.dimension.smallSpace
        return view
    }()
    
    let disagreeVoteUsers: UIStackView = {
        let view = UIStackView()
        view.distribution = .equalSpacing
        view.axis = .horizontal
        view.spacing = Style.dimension.smallSpace
        return view
    }()
    
    let motivateLabel: UILabel = {
        let label = UILabel()
        label.text = "찬반 투표하면 현재 결과를 볼 수 있습니다."
        label.textColor = .app_gray
        label.font = Style.font.smallThin
        return label
    }()

    func handleVote(poll: Poll, choice: String) {
        guard let user = UserSession.sharedInstance.user else { return }
        VotingRequestFactory.post(pollId: poll.id, choice: choice).resume { [weak self] (response, error) in
            guard let strongSelf = self, let poll = strongSelf.post?.poll else { return }
            if let _ = error {
                // TODO: 일반 오류인지, 네트워크 오류인지 처리 필요
                return
            }
            
            poll.vote(choice, by: user)
            strongSelf.setupVoteButtons(poll: poll)
            strongSelf.setupVoteUsers(poll: poll)
        }
    }
    
    var forceWidth = CGFloat(0) {
        didSet {
            if post != nil {
                fatalError("데이터가 지정되기 전에 폭을 설정해야 합니다")
            }
        }
    }
    
    var post: Post? {
        didSet {
            guard let poll = post?.poll else { return }
        
            titleLabel.text = poll.title
            setupVoteButtons(poll: poll)
            setupVoteUsers(poll: poll)
            setNeedsLayout()
        }
    }
    
    fileprivate func setupVoteButtons(poll: Poll) {
        setupVoteButton(button: agreeButton,
                          title: "찬성", titleImage: #imageLiteral(resourceName: "thumbs_up"),
                          count: poll.agreedVotingsCount,
                          voted: poll.isVoted(),
                          chosen: poll.isAgreed(),
                          color: UIColor(r: 57, g: 114, b: 100))
        setupVoteButton(button: disagreeButton,
                          title: "반대", titleImage: #imageLiteral(resourceName: "thumbs_down"),
                          count: poll.disagreedVotingsCount,
                          voted: poll.isVoted(),
                          chosen: poll.isDisagreed(),
                          color: UIColor(r: 190, g: 88, b: 95))
    }
    
    fileprivate func setupVoteButton(button: UIButton, title: String, titleImage: UIImage, count: Int, voted: Bool, chosen: Bool, color: UIColor) {
        let titleColor = chosen ? UIColor.white : ( voted ? .app_light_gray : color )
        let titleText = buildVoteButtonText(title: title, titleImage: titleImage, count: count, voted: voted, titleColor: titleColor)
        button.setAttributedTitle(titleText, for: .normal)
        button.backgroundColor = chosen ? color : UIColor.clear
        button.layer.borderColor = (chosen ? color : ( voted ? .app_light_gray : color )).cgColor
    }
    
    fileprivate func buildVoteButtonText(title: String, titleImage: UIImage, count: Int, voted: Bool, titleColor: UIColor) -> NSAttributedString {
        var elements: [Composable] = [
            titleImage.withRenderingMode(.alwaysOriginal).tintedImage(color: titleColor).styled(with: .baselineOffset(-4)),
            Special.noBreakSpace,
            title.styled(with: .color(titleColor))
        ]
        if voted {
            elements.append(Special.carriageReturn)
            elements.append(String(value: count, max: 999).styled(with: Style.string.defaultNormal, .color(titleColor)))
        }
        return NSAttributedString.composed(of: elements, baseStyle: StringStyle(Style.string.defaultBold))
    }
    
    fileprivate func setupVoteUsers(poll: Poll) {
        agreeVoteUsers.removeAllArrangedSubviews()
        disagreeVoteUsers.removeAllArrangedSubviews()
        
        if poll.isVoted() {
            for user in poll.latestAgreedVotingUsers.reversed() {
                let userImage = UIImageView()
                userImage.kf.setImage(with: URL(string: user.imageUrl))
                Style.image(asProfile: userImage, width: Style.dimension.postCell.postVoteUserImageSize)
                agreeVoteUsers.addArrangedSubview(userImage)
                userImage.anchor(widthConstant: Style.dimension.postCell.postVoteUserImageSize, heightConstant: Style.dimension.postCell.postVoteUserImageSize)
            }
            
            for user in poll.latestDisagreedVotingUsers {
                let userImage = UIImageView()
                userImage.kf.setImage(with: URL(string: user.imageUrl))
                Style.image(asProfile: userImage, width: Style.dimension.postCell.postVoteUserImageSize)
                disagreeVoteUsers.addArrangedSubview(userImage)
                userImage.anchor(widthConstant: Style.dimension.postCell.postVoteUserImageSize, heightConstant: Style.dimension.postCell.postVoteUserImageSize)
            }
            agreeVoteUsers.isHidden = false
            disagreeVoteUsers.isHidden = false
            motivateLabel.isHidden = true
        } else {
            agreeVoteUsers.isHidden = true
            disagreeVoteUsers.isHidden = true
            motivateLabel.isHidden = false
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    fileprivate func setupView() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.app_light_gray.cgColor
        layer.cornerRadius = Style.dimension.defaultRadius
        layer.masksToBounds = true
        
        addSubview(titleLabel)
        addSubview(agreeButton)
        addSubview(disagreeButton)
        addSubview(agreeVoteUsers)
        addSubview(disagreeVoteUsers)
        addSubview(motivateLabel)
        
        titleLabel.anchor(topAnchor, left: leftAnchor, right: rightAnchor,
                          topConstant: Style.dimension.postCell.pollPadding,
                          leftConstant: Style.dimension.postCell.pollPadding,
                          rightConstant: Style.dimension.postCell.pollPadding)
        agreeButton.anchor(titleLabel.bottomAnchor, topConstant: Style.dimension.defaultSpace,
                           widthConstant: Style.dimension.postCell.pollVoteButtonWidth, heightConstant: Style.dimension.postCell.pollVoteButtonHeight)
        agreeButton.anchorCenterXToSuperview(constant: -1 * (Style.dimension.postCell.pollVoteButtonWidth / 2 + Style.dimension.defaultSpace / 2))
        disagreeButton.anchor(titleLabel.bottomAnchor, topConstant: Style.dimension.defaultSpace,
                           widthConstant: Style.dimension.postCell.pollVoteButtonWidth, heightConstant: Style.dimension.postCell.pollVoteButtonHeight)
        disagreeButton.anchorCenterXToSuperview(constant: +1 * (Style.dimension.postCell.pollVoteButtonWidth / 2 + Style.dimension.defaultSpace / 2))
        
        agreeVoteUsers.anchor(agreeButton.bottomAnchor, bottom: bottomAnchor, right: agreeButton.rightAnchor,
                              topConstant: Style.dimension.defaultSpace, bottomConstant: Style.dimension.defaultSpace, rightConstant: Style.dimension.defaultSpace,
                              heightConstant: Style.dimension.postCell.postVoteUserImageSize)
        disagreeVoteUsers.anchor(disagreeButton.bottomAnchor, left: disagreeButton.leftAnchor, bottom: bottomAnchor,
                                 topConstant: Style.dimension.defaultSpace, leftConstant: Style.dimension.defaultSpace, bottomConstant: Style.dimension.defaultSpace,
                                 heightConstant: Style.dimension.postCell.postVoteUserImageSize)
        motivateLabel.anchor(agreeButton.bottomAnchor, bottom: bottomAnchor,
                             topConstant: Style.dimension.defaultSpace, bottomConstant: Style.dimension.defaultSpace,
                             heightConstant: Style.dimension.postCell.postVoteUserImageSize)
        motivateLabel.anchorCenterXToSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: forceWidth, height: PollView.estimateHeight(post: post, width: forceWidth))
    }
    
    func visible() -> Bool {
        return PollView.visible(post)
    }

    static func visible(_ post: Post?) -> Bool {
        return post?.poll != nil
    }
    
    static func estimateHeight(post: Post?, width: CGFloat) -> CGFloat {
        guard let poll = post?.poll, PollView.visible(post) else { return CGFloat(0) }
        
        let labelWidth = width - (Style.dimension.postCell.pollPadding * 2)
        let titleLableHeight = UILabel.estimateHeight(text: poll.title, width: labelWidth, of: PollView.prototype.titleLabel)

        return titleLableHeight + CGFloat(Style.dimension.postCell.pollPadding * 2) + estimateVoteButtonHeight() + estimateVoteUsersHeight()
    }
    
    fileprivate static func estimateVoteButtonHeight() -> CGFloat {
        return Style.dimension.defaultSpace + Style.dimension.postCell.pollVoteButtonHeight
    }
    
    fileprivate static func estimateVoteUsersHeight() -> CGFloat {
        return Style.dimension.defaultSpace + Style.dimension.postCell.postVoteUserImageSize
    }
}
