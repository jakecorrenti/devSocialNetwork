//
//  MessagedUserCell.swift
//  DevSocial
//
//  Created by Jake Correnti on 4/3/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import Firebase

class MessagedUserCell: UITableViewCell {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var dateFormatter: DateFormatter {
        let formatter 		 = DateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        return formatter
    }
	
	var activityDateLabelEstimatedSize = CGSize()
    
    var selectedUser: User! {
        didSet {
            avatarView.user    = selectedUser
            usernameLabel.text = selectedUser.username
            MessagesManager.shared.getLastSentChat(with: selectedUser) { [weak self] message in
				guard let self = self else { return }
                if let message = message {
                    self.lastMessageLabel.text          = message.content
                    self.recentActivityDateLabel.text   = self.dateFormatter.string(from: message.created.dateValue())
					self.updateActivityDateLabelWidthConstraint()
					if !message.wasRead && message.senderID != Auth.auth().currentUser?.uid {
						self.unreadIndicator.isHidden   = false
					} else {
						self.unreadIndicator.isHidden   = true
					}
                    
                }
            }
        }
    }
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------

    lazy var avatarView: AvatarView = {
        let view 					   = AvatarView()
        view.bgView.layer.cornerRadius = 25
        return view
    }()

    lazy var unreadIndicator: UIView = {
        let view 			    = UIView()
		view.isHidden			= true
        view.backgroundColor 	= UIColor(named: ColorNames.mainColor)
        view.layer.cornerRadius = 7.5
        view.layer.borderColor  = UIColor.systemBackground.cgColor
        view.layer.borderWidth  = 2
        return view
    }()
	
	lazy var recentActivityDateLabel: UILabel = {
		let view 	   = UILabel()
		view.textColor = UIColor(named: ColorNames.secondaryTextColor)
		view.font 	   = .systemFont(ofSize: 13)
		return view
	}()
	
	lazy var usernameLabel: UILabel = {
		let view  = UILabel()
		view.font = .boldSystemFont(ofSize: 18)
		return view
	}()
	
	lazy var lastMessageLabel: UILabel = {
		let view       = UILabel()
		view.textColor = UIColor(named: ColorNames.secondaryTextColor)
		view.font      = .systemFont(ofSize: 13)
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
        [avatarView, unreadIndicator, recentActivityDateLabel, usernameLabel, lastMessageLabel].forEach { addSubview($0) }

        constrainAvatarView()
		constrainUnreadIndicator()
		constrainRecentActivityDateLabel()
		constrainUsernameLabel()
		constrainLastMessageLabel()
    }

    private func constrainAvatarView() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            avatarView.heightAnchor.constraint(equalToConstant: 50),
            avatarView.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func constrainUnreadIndicator() {
        unreadIndicator.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			unreadIndicator.topAnchor.constraint(equalTo: avatarView.topAnchor),
			unreadIndicator.leadingAnchor.constraint(equalTo: avatarView.leadingAnchor),
			unreadIndicator.heightAnchor.constraint(equalToConstant: 15),
			unreadIndicator.widthAnchor.constraint(equalToConstant: 15)
		])
    }
	
	private func constrainRecentActivityDateLabel() {
		recentActivityDateLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			recentActivityDateLabel.topAnchor.constraint(equalTo: avatarView.topAnchor),
			recentActivityDateLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
			recentActivityDateLabel.widthAnchor.constraint(equalToConstant: 0)
		])
	}
	
	private func constrainUsernameLabel () {
		usernameLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			usernameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 13),
			usernameLabel.bottomAnchor.constraint(equalTo: avatarView.centerYAnchor),
			usernameLabel.trailingAnchor.constraint(equalTo: recentActivityDateLabel.leadingAnchor, constant: -8)
		])
	}
	
	private func constrainLastMessageLabel() {
		lastMessageLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			lastMessageLabel.leadingAnchor.constraint(equalTo: usernameLabel.leadingAnchor),
			lastMessageLabel.topAnchor.constraint(equalTo: avatarView.centerYAnchor, constant: 4),
			lastMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
		])
	}
	
	private func updateActivityDateLabelWidthConstraint() {
		let size = CGSize(width: self.frame.width, height: .infinity)
		let estimatedSize = recentActivityDateLabel.sizeThatFits(size)
		
		recentActivityDateLabel.constraints.forEach { constraint in
			if constraint.firstAttribute == .width {
				constraint.constant = estimatedSize.width
			}
		}
	}

}

