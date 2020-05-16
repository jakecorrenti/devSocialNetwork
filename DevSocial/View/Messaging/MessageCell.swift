//
//  MessageCell.swift
//  DevSocial
//
//  Created by Jake Correnti on 4/1/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Firebase

class MessageCell: UITableViewCell {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var contentLeading  : NSLayoutConstraint!
    var contentTrailing : NSLayoutConstraint!
	var avatarLeading   : NSLayoutConstraint!
	var avatarTrailing  : NSLayoutConstraint!
    
    var message: Message! {
        didSet {
            self.contentLabel.text     = message.content
            bubbleView.backgroundColor = message.senderID == Auth.auth().currentUser?.uid ? UIColor(named: ColorNames.mainColor) : UIColor(named: ColorNames.accessory)
            contentLabel.textColor     = message.senderID == Auth.auth().currentUser?.uid ? .white : UIColor(named: ColorNames.primaryTextColor)
            
            if message.senderID == Auth.auth().currentUser?.uid {
                self.contentLeading.isActive  = false
				self.avatarLeading.isActive   = false
				self.avatarTrailing.isActive  = true
                self.contentTrailing.isActive = true
			} else {
                self.contentLeading.isActive  = true
				self.avatarLeading.isActive   = true
				self.avatarTrailing.isActive  = false
                self.contentTrailing.isActive = false
            }
        }
    }
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
	
	lazy var avatarView: AvatarView = {
		let view 					   = AvatarView()
		view.bgView.layer.cornerRadius = 15
		return view
	}()
    
    lazy var contentLabel: UILabel = {
        let view		   = UILabel()
        view.numberOfLines = 0
        return view
    }()
    
    lazy var bubbleView: UIView = {
        let view 			     = UIView()
         view.layer.cornerRadius = 15
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
    
    private func setupUI() {
		[avatarView, bubbleView, contentLabel].forEach { addSubview($0) }
		
		constrainContentLabel()
		constrainBubbleView()
		constrainAvatarView()
        setDynamicLeadingAndTrailingConstraints()
    }

    private func setDynamicLeadingAndTrailingConstraints() {
        avatarLeading   = avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        avatarTrailing  = avatarView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        contentLeading  = contentLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 14)
        contentTrailing = contentLabel.trailingAnchor.constraint(equalTo: avatarView.leadingAnchor, constant: -14)
    }

	
	private func constrainAvatarView() {
		avatarView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			avatarView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor),
			avatarView.heightAnchor.constraint(equalToConstant: 30),
			avatarView.widthAnchor.constraint(equalToConstant: 30)
		])
	}
	
	private func constrainContentLabel() {
		contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            contentLabel.widthAnchor.constraint(lessThanOrEqualToConstant: self.frame.width * 0.85)
        ])
	}
	
	private func constrainBubbleView() {
		bubbleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentLabel.topAnchor, constant: -10),
            bubbleView.leadingAnchor.constraint(equalTo: contentLabel.leadingAnchor, constant:  -10),
            bubbleView.trailingAnchor.constraint(equalTo: contentLabel.trailingAnchor, constant: 10),
            bubbleView.bottomAnchor.constraint(equalTo: contentLabel.bottomAnchor, constant: 10)
        ])
	}
}
