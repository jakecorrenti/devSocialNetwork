//
//  SignupVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/28/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class SignupVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var welcomeLabel: UILabel = {
        let view = UILabel()
        view.text = "Welcome to DevSocial!"
        view.font = .boldSystemFont(ofSize: 30)
        return view
    }()
    
    lazy var tfStack: TextFieldStack = {
        let view = TextFieldStack()
        view.configure(
            placeholders: ["Username", "Email", "Password"],
            keyboardType: [.default, .emailAddress, .default],
            isSecure: [false, false, true])
        return view
    }()
    
    lazy var signupButton: GreenCapsuleButton = {
        let view = GreenCapsuleButton(type: .system)
        view.configure(title: "Sign up")
        view.addTarget(self, action: #selector(signupButtonPressed), for: .touchUpInside)
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
        [welcomeLabel, tfStack, signupButton].forEach { view.addSubview($0) }
        
        constrainWelcomeLabel()
        constrainTFStack()
        constrainSignUpButton()
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
    
    private func constrainSignUpButton() {
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            signupButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            signupButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            signupButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            signupButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func checkUnacceptedUsername( username: String, nonAccepted: [String] ) -> Bool {
        for i in nonAccepted {
            if username.contains(i) {
                return true
            }
        }
        return false
    }
    
    func verifyUsername(username: String, verified: @escaping (Bool?) -> Void) {
        
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        
        if username.rangeOfCharacter(from: characterset.inverted) != nil {
            Alert.showBasicAlert(on: self, with: "Error", message: "Usernames must only contain letters or numbers")
            verified(false)
        }
        
        let whitespace = NSCharacterSet.whitespaces
        
        let range = username.rangeOfCharacter(from: whitespace)
        
        if range != nil {
            Alert.showBasicAlert(on: self, with: "Error", message: "Usernames cannot contain white space")
            verified(false)
        }
        
        let nonAccepted: [String] = ["fuck", "shit", "cunt", "fag", "faggot", "bitch", "retard", "queer", "queef", "nigger", "nigga"]
        
        if checkUnacceptedUsername(username: username, nonAccepted: nonAccepted) == true {
            Alert.showBasicAlert(on: self, with: "Error", message: "Usernames cannot contain graphic / foul language")
            verified(false)
        }
        
        if username.count < 3 || username.count > 20 {
            Alert.showBasicAlert(on: self, with: "Error", message: "Usernames have to be in between 3 and 20 characters")
            verified(false)
        }
        
        // Check if the username exists in the database, if it does then return false, if it does not then return true
        FirebaseStorageContext.shared.checkUsernameExists(username: username, onError: { (error) in
            Alert.showBasicAlert(on: self, with: "Error", message: error?.localizedDescription)
            verified(false)
        }) { (exists) in
            if exists! {
                Alert.showBasicAlert(on: self, with: "Error", message: "Usernames is already taken")
                verified(false)
            } else {
                verified(true)
            }
        }
    }
    
    @objc func signupButtonPressed() {
        showLoadingView()
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
        if populatedCount == 3 {
            var password: String = ""
            var email: String = ""
            var username: String = ""
            textFields.enumerated().forEach { (index, tf) in
                switch index {
                case 0:
                    username = tf.text!
                case 1:
                    email = tf.text!
                case 2:
                    password = tf.text!
                default:
                    print("Index out of bounds")
                }
            }
            
            // Verify the username, if the function returns true then create user, if the function returns false then show error
            verifyUsername(username: username) { (verified) in
                if let ver = verified {
                    if ver {
                        AuthManager.shared.createUserWithFirebase(username: username, email: email, password: password) { [weak self] (error) in
                            guard let self = self else { return }
                            if let error = error {
                                Alert.showBasicAlert(on: self, with: "Oh no!", message: error.localizedDescription)
                            } else {
                                self.dismissLoadingView()
                            }
                        }
                    }
                } else {
                    Alert.showBasicAlert(on: self, with: "Error", message: "Could not unwrap verified")
                }
            }
            
        } else {
            Alert.showFillAllFieldsAlert(on: self)
        }
    }
}
