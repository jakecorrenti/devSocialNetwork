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
    
	lazy var bgView: UIView = {
		let view 			    = UIView()
		view.layer.cornerRadius = 12
		view.backgroundColor    = UIColor(named: ColorNames.accessory)
		return view
	}()
	
	lazy var textField: UITextField = {
		let view 	     = UITextField()
		view.placeholder = "Enter message..."
		view.addTarget(self, action: #selector(manageSendButtonState), for: .editingChanged)
		return view
	}()
	
	lazy var sendButton: UIButton = {
		let view 			    = UIButton(type: .system)
		view.layer.cornerRadius = 12
		view.backgroundColor    = UIColor(named: ColorNames.mainColor)
		view.setTitle("↑", for: .normal)
		view.setTitleColor(.white, for: .normal)
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
		[bgView, sendButton, textField].forEach { addSubview($0) }
		
		constrainBgView()
		constrainSendButton()
		constrainTextField()
		setSendButtonDeactivatedState()
    }
    
	private func constrainBgView() {
		bgView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			bgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
			bgView.topAnchor.constraint(equalTo: topAnchor),
			bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
			bgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
		])
	}
	
	private func constrainSendButton() {
		sendButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			sendButton.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -4),
			sendButton.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 4),
			sendButton.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -4),
			sendButton.widthAnchor.constraint(equalToConstant: 42)
		])
	}
	
	private func constrainTextField() {
		textField.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			textField.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 4),
			textField.topAnchor.constraint(equalTo: sendButton.topAnchor),
			textField.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -4),
			textField.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -4)
		])
	}
	
	func setSendButtonDeactivatedState() {
		sendButton.backgroundColor = .systemGray5
		sendButton.isEnabled	   = false
	}
	
	func setSendButtonActivatedState() {
		sendButton.backgroundColor = UIColor(named: ColorNames.mainColor)
		sendButton.isEnabled	   = true
	}
	
	@objc
	private func manageSendButtonState() {
		let contents = textField.text
		if contents == nil || contents == "" {
			setSendButtonDeactivatedState()
		} else {
			let trimmedContents = contents?.trimmingCharacters(in: .whitespacesAndNewlines)
			if trimmedContents == nil || trimmedContents == "" {
				setSendButtonDeactivatedState()
			} else {
				setSendButtonActivatedState()
			}
		}
	}

}
