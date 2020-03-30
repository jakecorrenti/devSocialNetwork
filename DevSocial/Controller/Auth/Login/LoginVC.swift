//
//  LoginVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/28/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import AuthenticationServices
import CryptoKit

class LoginVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var currentNonce: String?
    
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
        view.configure(
            placeholders: ["Email", "Password"],
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
    let googleButton = GIDSignInButton()
    let appleButton = ASAuthorizationAppleIDButton()
    
    lazy var loginButton: GreenCapsuleButton = {
        let view = GreenCapsuleButton(type: .system)
        view.configure(title: "Login")
        view.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return view
    }()
    
    
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
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
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }
    
    private func setupUI() {
        [welcomeLabel, tfStack, forgotPasswordButton, signInWithGoogleView, googleButton, loginButton, appleButton].forEach { view.addSubview($0) }
        
        constrainWelcomeLabel()
        constrainTFStack()
        constrainForgotPasswordButton()
        constrainSignInWithGoogleView()
        constrainGoogleButton()
        constrainAppleButton()
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
    
    private func constrainGoogleButton() {
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            googleButton.topAnchor.constraint(equalTo: signInWithGoogleView.orLabel.bottomAnchor, constant: 16),
            googleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            googleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func constrainAppleButton() {
        appleButton.addTarget(self, action: #selector(appleLoginButtonPressed), for: .touchUpInside)
        appleButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            appleButton.topAnchor.constraint(equalTo: googleButton.bottomAnchor, constant: 16),
            appleButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            appleButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            appleButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    @objc func loginButtonPressed() {
        var populatedCount = 0
        var textFields = [CustomTextField]()
        
        /*
         loops through each view in the stack view, and check if it is of type CustomTextField
         if it is, it adds it to the array of text fields
         checks if the textfield is populated and does not have a space as its text, and if it is not empty, the number of text fields populated is incremented
         */
        tfStack.stackView.arrangedSubviews.forEach { tf in
            if tf.isKind(of: CustomTextField.self) {
                let tf = tf as! CustomTextField
                if tf.text!.isNotEmpty {
                    populatedCount += 1
                    textFields.append(tf)
                }
            }
        }
        
        // if all the text fields are populated, retrieve the text from each, and then make the call to sign up the user
        if populatedCount == 2 {
            var password: String = ""
            var email: String = ""
            textFields.enumerated().forEach { (index, tf) in
                switch index {
                case 0:
                    email = tf.text!
                case 1:
                    password = tf.text!
                default:
                    print("Index out of bounds")
                }
            }
            
            let authManager = AuthManager()
            authManager.signInWithFirebase(email: email, password: password) { (error) in
                if let error = error {
                    Alert.showBasicAlert(on: self, with: "Oh no!", message: error.localizedDescription)
                }
            }
        } else {
            Alert.showFillAllFieldsAlert(on: self)
        }
    }
}
