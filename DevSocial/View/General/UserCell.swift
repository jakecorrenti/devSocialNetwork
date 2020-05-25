//
//  UserCell.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 5/14/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            profileImageView.image = UIImage(named: Images.emptyProfileImage)
            authorNameView.text = user.username
            authorHeadlineView.text = user.headline
        }
    }
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    lazy var authorNameView : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 16)
        label.textColor = UIColor(named: ColorNames.primaryTextColor)
        return label
    }()
    
    lazy var authorHeadlineView : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 14)
        label.textColor = UIColor(named: ColorNames.secondaryTextColor)
        return label
    }()
    
    lazy var authorStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [authorNameView, authorHeadlineView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    lazy var finalStack : UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageView, authorStack])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 10
        return stack
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
        self.addSubview(finalStack)
                
        setupAuthorStack()
    }
    
    private func setupAuthorStack() {
        let margins = self.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            authorNameView.heightAnchor.constraint(equalToConstant: 20),
            authorStack.heightAnchor.constraint(equalToConstant: 40),
            profileImageView.heightAnchor.constraint(equalToConstant: 40),
            profileImageView.widthAnchor.constraint(equalToConstant: 40),
            finalStack.topAnchor.constraint(equalTo: margins.topAnchor),
            finalStack.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            finalStack.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            finalStack.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            finalStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 40)
        ])
    }
}
