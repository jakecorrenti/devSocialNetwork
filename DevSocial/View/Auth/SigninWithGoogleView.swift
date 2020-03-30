//
//  SigninWithGoogleView.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/29/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import GoogleSignIn

class SigninWithGoogleView: UIView {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var orLabel: UILabel = {
        let view = UILabel()
        view.text = "OR"
        view.font = .systemFont(ofSize: 15)
        view.textColor = .systemGray
        view.textAlignment = .center
        return view
    }()
    
    lazy var leftBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    lazy var rightBar: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    lazy var googleSigninButton: UIButton = {
        let view = UIButton()
        view.setTitle("Sign in with Google", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.backgroundColor = .systemGray
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
        [orLabel, leftBar, rightBar, googleSigninButton].forEach { addSubview($0) }
        
        constrainOrLabel()
        constrainLeftBar()
        constrainRightBar()
    }
    
    private func constrainOrLabel() {
        orLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            orLabel.topAnchor.constraint(equalTo: topAnchor),
            orLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    private func constrainLeftBar() {
        leftBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leftBar.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor),
            leftBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            leftBar.trailingAnchor.constraint(equalTo: orLabel.leadingAnchor, constant: -8),
            leftBar.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
    
    private func constrainRightBar() {
        rightBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rightBar.centerYAnchor.constraint(equalTo: orLabel.centerYAnchor),
            rightBar.leadingAnchor.constraint(equalTo: orLabel.trailingAnchor, constant: 8),
            rightBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            rightBar.heightAnchor.constraint(equalToConstant: 2)
        ])
    }
}
