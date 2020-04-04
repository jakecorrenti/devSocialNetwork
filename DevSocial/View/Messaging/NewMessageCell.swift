//
//  NewMessageCell.swift
//  DevSocial
//
//  Created by Jake Correnti on 4/3/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class NewMessageCell: UITableViewCell {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var selectedUser: User! {
        didSet {
            avatarView.user = selectedUser
            usernameLabel.text = selectedUser.username
        }
    }
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    let avatarView = AvatarView()
    
    lazy var usernameLabel: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 18)
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
        [avatarView, usernameLabel].forEach { addSubview($0) }
        
        constrainAvatarView()
        constrainUserameLabel()
    }
    
    private func constrainAvatarView() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 45),
            avatarView.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func constrainUserameLabel() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            usernameLabel.leadingAnchor.constraint(equalTo: avatarView.trailingAnchor, constant: 8),
            usernameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}

