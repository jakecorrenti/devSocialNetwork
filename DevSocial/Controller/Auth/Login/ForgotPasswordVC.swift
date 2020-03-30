//
//  ForgotPasswordVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/30/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Firebase

class ForgotPasswordVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Forget your password?"
        view.font = .boldSystemFont(ofSize: 30)
        view.textAlignment = .center
        return view
    }()
    
    lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Enter your email and we will send you a password reset email."
        view.font = .systemFont(ofSize: 18)
        view.textColor = .systemGray
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    lazy var emailTextField: CustomTextField = {
        let view = CustomTextField()
        view.configure(placeholder: "Email", keyboardType: .emailAddress)
        return view
    }()
    
    lazy var submitButton: GreenCapsuleButton = {
        let view = GreenCapsuleButton(type: .system)
        view.configure(title: "Send Email")
        view.addTarget(self, action: #selector(submitButtonPressed), for: .touchUpInside)
        return view
    }()
    
    lazy var titleStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.titleLabel, self.subtitleLabel])
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
    lazy var inputStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.emailTextField, self.submitButton])
        view.axis = .vertical
        view.spacing = 36
        view.distribution = .fillEqually
        return view
    }()
    
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        tabBarController?.tabBar.isHidden = false
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
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func setupUI() {
        [titleStack, inputStack].forEach { view.addSubview($0) }
        
        constrainTitleStack()
        constrainInputStack()
    }
    
    private func constrainTitleStack() {
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func constrainInputStack() {
        inputStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            inputStack.bottomAnchor.constraint(equalTo: view.centerYAnchor),
            inputStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            inputStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            inputStack.heightAnchor.constraint(equalToConstant: 136)
        ])
    }
    
    @objc
    func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    func submitButtonPressed() {
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { error in
          // ...
            if let error = error {
                Alert.showBasicAlert(on: self, with: "Oh no!", message: error.localizedDescription)
            } else {
                print("SUCCESS")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
