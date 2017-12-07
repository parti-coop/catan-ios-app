//
//  CommentForm.swift
//  catan
//
//  Created by Youngmin Kim on 2017. 11. 11..
//  Copyright © 2017년 Parti. All rights reserved.
//

import UIKit

protocol CommentFormViewDelegate: class {
    func handleCommentSubmit(body: String)
}

class CommentFormView: UIView {
    weak var delegate: CommentFormViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let submitButton: UIButton = {
        let submitButton = UIButton(type: .system)
        submitButton.setTitle("저장", for: .normal)
        submitButton.setTitleColor(.black, for: .normal)
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)

        return submitButton
    }()
    
    // 댓글 생성하기
    
    @objc func handleSubmit() {
        guard let body = textField.text else { return }
        clearForm()
        if body.isPresent() {
            self.delegate?.handleCommentSubmit(body: body)
        } else {
            textField.resignFirstResponder()
        }
    }

    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "댓글을 입력하세요"
        return textField
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = .app_light_gray
        return view
    }()
    
    fileprivate func setupViews() {
        backgroundColor = .white
        frame = CGRect(x: 0, y: 0, width: frame.width, height: 50)
        
        addSubview(submitButton)
        submitButton.anchor(topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 0)

        addSubview(self.textField)
        self.textField.anchor(topAnchor, left: leftAnchor, bottom: bottomAnchor, right: submitButton.leftAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        addSubview(self.dividerView)
        self.dividerView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
    }
    
    func clearForm() {
        textField.text = ""
        textField.resignFirstResponder()
    }
}
