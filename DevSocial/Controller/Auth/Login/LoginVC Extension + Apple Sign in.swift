//
//  LoginVC Extension + Apple Sign in.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/30/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import AuthenticationServices
import Firebase
import CryptoKit
import FirebaseFirestore

extension LoginVC {
    
    // -----------------------------------------
    // MARK: Apple Login Logic
    // -----------------------------------------
    
    @objc
    func appleLoginButtonPressed() {
        startSignInWithAppleFlow()
    }

	/// generate a cryptographically secure nonce and then use it when making an authorization request from Apple
	private func randomNonceString(length: Int = 32) -> String {
		precondition(length > 0)
		let charset: Array<Character> =
				Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
		var result = ""
		var remainingLength = length

		while remainingLength > 0 {
			let randoms: [UInt8] = (0 ..< 16).map { _ in
				var random: UInt8 = 0
				let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
				if errorCode != errSecSuccess {
					fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
				}
				return random
			}

			randoms.forEach { random in
				if remainingLength == 0 {
					return
				}

				if random < charset.count {
					result.append(charset[Int(random)])
					remainingLength -= 1
				}
			}
		}

		return result
	}

	private func sha256(_ input: String) -> String {
		let inputData  = Data(input.utf8)
		let hashedData = SHA256.hash(data: inputData)
		let hashString = hashedData.compactMap {
			return String(format: "%02x", $0)
		}.joined()

		return hashString
	}
    
	private func startSignInWithAppleFlow() {
		showLoadingView()
		let appleIDProvider = ASAuthorizationAppleIDProvider()
		let request = appleIDProvider.createRequest()
		request.requestedScopes = [.fullName, .email]

		// Generate nonce for validation after authentication successful
		self.currentNonce = randomNonceString()
		// Set the SHA256 hashed nonce to ASAuthorizationAppleIDRequest
		request.nonce = sha256(currentNonce!)

		// Present Apple authorization form
		let authorizationController = ASAuthorizationController(authorizationRequests: [request])
		authorizationController.delegate = self
		authorizationController.presentationContextProvider = self
		authorizationController.performRequests()
	}
	
	private func checkIfCurrentUserExists(handler: @escaping (_ userStatus: Bool) -> Void) {
		Firestore.firestore().collection("users").document(Auth.auth().currentUser!.uid).getDocument { [weak self] (documentSnapshot, error) in
			guard let self = self else { return }
			if let error = error {
				Alert.showBasicAlert(on: self, with: error.localizedDescription)
			} else {
				handler(documentSnapshot!.exists)
			}
		}
	}
}

extension LoginVC: ASAuthorizationControllerDelegate {
	func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
		if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {

			// Retrieve the secure nonce generated during Apple sign in
			guard let nonce = currentNonce else {
				fatalError("Invalid state: A login callback was received, but no login request was sent.")
			}
			// Retrieve Apple identity token
			guard let appleIDToken = appleIDCredential.identityToken else {
				print("Failed to fetch identity token")
				return
			}
			// Convert Apple identity token to string
			guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
				print("Failed to decode identity token")
				return
			}
			// Initialize a Firebase credential using secure nonce and Apple identity token
			let firebaseCredential = OAuthProvider.credential(
					withProviderID : "apple.com",
					idToken        : idTokenString,
					rawNonce       : nonce
			)
			
			AuthManager.shared.signInWithAppleUser(credential: firebaseCredential, user: appleIDCredential, onSuccess: {
				print("Success")
			}) { [weak self] (error) in
				guard let self = self else { return }
				if let error = error {
					Alert.showBasicAlert(on: self, with: error.localizedDescription)
				} else {
					self.dismissLoadingView()
				}
			}
		}
	}
	
	func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
		// handle errors here
		Alert.showBasicAlert(on: self, with: error.localizedDescription)
	}
}

extension LoginVC: ASAuthorizationControllerPresentationContextProviding {
	func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
		return view.window!
	}
}
