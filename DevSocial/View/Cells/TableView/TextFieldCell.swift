//
//  TextFieldCell.swift
//  DevSocial
//
//  Created by Jake Correnti on 6/1/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {
	
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
	
	lazy var textField: UITextField = {
		let view = UITextField()
		view.delegate = self
		return view
	}()
	
    // -----------------------------------------
    // MARK: Initialization
    // -----------------------------------------
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
	
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    func setupUI() {
        addSubview(textField)
		textField.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
			textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
			textField.heightAnchor.constraint(equalToConstant: 40),
			textField.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
    }
	
	func configure(placeholder: String) {
		textField.placeholder = placeholder
	}
	
	func configure(placeholder: String, keyboardType: UIKeyboardType) {
		textField.placeholder = placeholder
		textField.keyboardType = keyboardType
	}
}

extension TextFieldCell: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
}
