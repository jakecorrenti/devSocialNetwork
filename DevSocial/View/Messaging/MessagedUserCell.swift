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
        let formatter = DateFormatter()
        formatter.dateFormat = "M/d/yyyy"
        return formatter
    }
    
    var selectedUser: User!{
        didSet {
            avatarView.user = selectedUser
            usernameLabel.text = selectedUser.username
            MessagesManager.shared.getLastSentChat(with: selectedUser) { (message) in
                if let message = message {
                    self.lastMessageLabel.text = message.content
                    self.recentMessageDateLabel.text = self.dateFormatter.string(from: message.created.dateValue())
                    
                    if message.senderID == Auth.auth().currentUser?.uid {
                        self.unreadIndicatorView.isHidden = true
                    } else {
                        if message.wasRead {
                            self.unreadIndicatorView.isHidden = true
                        }
                    }
                    
                } else {
                    self.lastMessageLabel.text = ""
                    self.recentMessageDateLabel.text = self.dateFormatter.string(from: Date())
                }
            }
        }
    }
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var unreadIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: ColorNames.mainColor)
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var usernameLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
        return view
    }()
    
    lazy var lastMessageLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 15)
        view.textColor = .systemGray
        view.numberOfLines = 0
        return view
    }()
    
    let avatarView = AvatarView()
    
    lazy var recentMessageDateLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 11)
        view.textColor = .systemGray
        return view
    }()
    
    lazy var textStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.usernameLabel, self.lastMessageLabel])
        view.axis = .vertical
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
        [unreadIndicatorView, avatarView, recentMessageDateLabel, textStack].forEach { addSubview($0) }
        
        constrainUnreadIndicator()
        constrainAvatarView()
        constrainDateLabel()
        constrainTextStack()
    }
    
    private func constrainUnreadIndicator() {
        unreadIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            unreadIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            unreadIndicatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            unreadIndicatorView.heightAnchor.constraint(equalToConstant: 12),
            unreadIndicatorView.widthAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    private func constrainAvatarView() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: unreadIndicatorView.trailingAnchor, constant: 8),
            avatarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 45),
            avatarView.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func constrainTextStack() {
        textStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            textStack.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            textStack.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            textStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: recentMessageDateLabel.leadingAnchor, constant: -8)
        ])
    }
    
    private func constrainDateLabel() {
        recentMessageDateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            recentMessageDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            recentMessageDateLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8)
        ])
    }
}

