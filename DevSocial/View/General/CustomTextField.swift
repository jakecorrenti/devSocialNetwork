//
//  CustomTextField.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/28/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
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
        borderStyle = .roundedRect
        font = .systemFont(ofSize: 15)
        backgroundColor = .systemBackground
        delegate = self
    }
    
    func configure(placeholder: String, keyboardType: UIKeyboardType = .default, isSecure: Bool = false) {
        self.placeholder = placeholder
        self.keyboardType = keyboardType
        self.isSecureTextEntry = isSecure
    }
}

extension CustomTextField: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
