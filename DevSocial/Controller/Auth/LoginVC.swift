//
//  LoginVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/28/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var welcomeLabel: UILabel = {
        let view = UILabel()
        view.text = "Welcome back!"
        view.font = .boldSystemFont(ofSize: 30)
        return view
    }()

    lazy var tfStack: TextFieldStack = {
        let view = TextFieldStack()
        view.configure(placeholders: ["Email", "Password"],
                       keyboardType: [.emailAddress, .default],
                       isSecure: [false, true])
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var forgotPasswordButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Forget password?", for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 15)
        view.setTitleColor(UIColor(named: ColorNames.mainColor), for: .normal)
        return view
    }()
    
    let signInWithGoogleView = SigninWithGoogleView()
    
    lazy var loginButton: GreenCapsuleButton = {
        let view = GreenCapsuleButton(type: .system)
        view.configure(title: "Login")
        return view
    }()
    
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupUI()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
        view.backgroundColor = UIColor(named: ColorNames.background)
    }
    
    private func setupUI() {
        [welcomeLabel, tfStack, forgotPasswordButton, signInWithGoogleView, loginButton].forEach { view.addSubview($0) }
        
        constrainWelcomeLabel()
        constrainTFStack()
        constrainForgotPasswordButton()
        constrainSignInWithGoogleView()
        constrainLoginButton()
    }
    
    private func constrainWelcomeLabel() {
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 24),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func constrainTFStack() {
        tfStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tfStack.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 45),
            tfStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tfStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func constrainForgotPasswordButton() {
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            forgotPasswordButton.topAnchor.constraint(lessThanOrEqualTo: tfStack.stackView.bottomAnchor, constant: 16),
            forgotPasswordButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func constrainSignInWithGoogleView() {
        signInWithGoogleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signInWithGoogleView.topAnchor.constraint(equalTo: forgotPasswordButton.bottomAnchor, constant: 36),
            signInWithGoogleView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            signInWithGoogleView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func constrainLoginButton() {
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            loginButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            loginButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
