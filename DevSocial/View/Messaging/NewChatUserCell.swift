//
// Created by Jake Correnti on 4/27/20.
// Copyright (c) 2020 Jake Correnti. All rights reserved.
//

import UIKit

class NewChatUserCell: UICollectionViewCell {

    //MARK: - Properties
    weak var removeUserDelegate: RemovedUserDelegate?

    var selectedUser: User! {
        didSet {
            avatarView.user    = selectedUser
            usernameLabel.text = selectedUser.username.replacingOccurrences(of: " ", with: "\n")
        }
    }

    //MARK: - Views

    lazy var cardBackgroundView: UIView = {
        let view                = UIView()
        view.backgroundColor    = .secondarySystemBackground
        view.layer.cornerRadius = 12
        return view
    }()

    lazy var removeButton: UIButton = {
        let view                = UIButton(type: .system)
		view.backgroundColor    = .systemRed
        view.layer.cornerRadius = 12.5
        view.titleLabel?.font   = .boldSystemFont(ofSize: 11)
        view.setTitle("X", for: .normal)
        view.setTitleColor(.white, for: .normal)
        view.addTarget(self, action: #selector(removeUserButtonPressed), for: .touchUpInside)
        return view
    }()

    lazy var avatarView: AvatarView = {
        let view = AvatarView()
        return view
    }()
    
    lazy var usernameLabel: UILabel = {
        let view           = UILabel()
        view.font          = .boldSystemFont(ofSize: 13)
        view.textAlignment = .center
        return view
    }()

    //MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupUI()
    }

    //MARK: - Setup UI

    private func setupUI() {
        [cardBackgroundView, removeButton, avatarView, usernameLabel].forEach { addSubview($0) }

        constrainCardBackgroundView()
        constrainRemoveButton()
        constrainAvatarView()
        constrainUsernameLabel()
    }

    private func constrainCardBackgroundView() {
        cardBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cardBackgroundView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cardBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            cardBackgroundView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cardBackgroundView.heightAnchor.constraint(equalToConstant: 115)
        ])
    }

    private func constrainRemoveButton() {
        removeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            removeButton.centerXAnchor.constraint(equalTo: cardBackgroundView.trailingAnchor),
            removeButton.centerYAnchor.constraint(equalTo: cardBackgroundView.topAnchor),
            removeButton.heightAnchor.constraint(equalToConstant: 25),
            removeButton.widthAnchor.constraint(equalToConstant: 25)
        ])
    }

    private func constrainAvatarView() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: cardBackgroundView.topAnchor, constant: 5),
            avatarView.centerXAnchor.constraint(equalTo: cardBackgroundView.centerXAnchor),
            avatarView.heightAnchor.constraint(equalToConstant: 45),
            avatarView.widthAnchor.constraint(equalToConstant: 45)
        ])
    }

    private func constrainUsernameLabel() {
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 10),
            usernameLabel.leadingAnchor.constraint(equalTo: cardBackgroundView.leadingAnchor, constant: 8),
            usernameLabel.trailingAnchor.constraint(equalTo: cardBackgroundView.trailingAnchor, constant: -8),
            usernameLabel.bottomAnchor.constraint(equalTo: cardBackgroundView.bottomAnchor, constant: -5)
        ])
    }

    @objc
    private func removeUserButtonPressed() {
        guard let delegate = removeUserDelegate else { return }
        delegate.userRemovedFromCollectionView(user: selectedUser)
    }

}
