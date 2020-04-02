//
//  InputView.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/31/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class InputView: UIView {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var sendButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Send", for: .normal)
        view.setTitleColor(UIColor(named: ColorNames.mainColor), for: .normal)
        return view
    }()
    
    lazy var separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.placeholder = "Enter message"
        view.backgroundColor = UIColor(named: ColorNames.background)
        return view
    }()
    
    // -----------------------------------------
    // MARK: Initialization
    // -----------------------------------------
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupUI() {
        [sendButton, separatorView, textField].forEach { addSubview($0) }
        
        constrainSendButton()
        constrainSeparatorView()
        constrainTextField()
    }
    
    private func constrainSendButton() {
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sendButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            sendButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    private func constrainSeparatorView() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            separatorView.widthAnchor.constraint(equalTo: widthAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func constrainTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor)
        ])
    }

}
