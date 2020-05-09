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
	
	lazy var textView: UITextView = {
		let view  			 = UITextView()
		view.font 			 = .systemFont(ofSize: 15)
		view.backgroundColor = UIColor(named: ColorNames.accessory)
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
		[bgView, sendButton, textView].forEach { addSubview($0) }
		
		bgView.layer.borderColor = UIColor(named: ColorNames.secondaryTextColor)?.cgColor
		bgView.layer.borderWidth = 0.25
		
		constrainSendButton()
		constrainTextView()
		constrainBGView()
		setSendButtonDeactivatedState()
    }
    
	private func constrainSendButton() {
		sendButton.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			sendButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
			sendButton.heightAnchor.constraint(equalToConstant: 35),
			sendButton.widthAnchor.constraint(equalToConstant: 35),
			sendButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
		])
	}
	
	private func constrainTextView() {
		textView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
			textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
			textView.trailingAnchor.constraint(equalTo: sendButton.leadingAnchor, constant: -4),
			textView.heightAnchor.constraint(equalToConstant: 35)
		])
	}
	
	private func constrainBGView() {
		bgView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			bgView.topAnchor.constraint(equalTo: textView.topAnchor, constant: -4),
			bgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4),
			bgView.bottomAnchor.constraint(equalTo: textView.bottomAnchor, constant: 4),
			bgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4)
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
}
