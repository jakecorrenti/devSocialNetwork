//
//  HomeRequestCell.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 3/31/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class HomeRequestCell: UITableViewCell {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            let formatter = DateFormatter()
            
            titleView.text = post.title
            // TODO: Add profile image support
            //            profileImageView.image = post.profile.profileImage
            profileImageView.image = UIImage(named: Images.emptyProfileImage)
            authorNameView.text = post.profile.username
            authorHeadlineView.text = post.profile.headline
            
            let datePosted = post.datePosted.dateValue()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            let dateString = formatter.string(from: datePosted)
            let days = Date().interval(ofComponent: .day, fromDate: datePosted)
            if days == 0 {
                dateView.text = "Posted Today (\(dateString))"
            } else if days == 1 {
                dateView.text = "Posted 1 Day ago (\(dateString))"
            } else {
                dateView.text = "Posted \(days) Days ago (\(dateString))"
            }
        }
    }
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    var titleView : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 18.0)
        label.textColor = UIColor(named: ColorNames.primaryTextColor)
        return label
    }()
    
    var profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = imageView.frame.width / 2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var authorNameView : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 14.0)
        label.textColor = UIColor(named: ColorNames.primaryTextColor)
        return label
    }()
    
    var authorHeadlineView : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 10.0)
        label.textColor = UIColor(named: ColorNames.secondaryTextColor)
        return label
    }()
    
    var authorStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    var finalStack : UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        return stack
    }()
    
    var dateView : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 12.0)
        label.textColor = UIColor(named: ColorNames.mainColor)
        return label
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
        let margins = self.layoutMarginsGuide
        
        [titleView, dateView].forEach { self.addSubview($0) }
        
        setTitleConstraints(margins: margins)
        
        setupAuthorStack(margins: margins)
        
        setDateConstraints(margins: margins)
    }
    
    private func setTitleConstraints(margins: UILayoutGuide) {
        titleView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleView.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        titleView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        titleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30.0).isActive = true
    }
    
    private func setupAuthorStack(margins: UILayoutGuide) {
        // MARK: Setup of the author name and headline stack
        authorNameView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        authorStack.addArrangedSubview(authorNameView)
        authorStack.addArrangedSubview(authorHeadlineView)
        
        authorStack.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        
        // MARK: Setup of the profile picture
        profileImageView.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        
        // MARK: Setup of the entire middle stack
        finalStack.addArrangedSubview(profileImageView)
        finalStack.addArrangedSubview(authorStack)
        
        self.addSubview(finalStack)
        
        finalStack.topAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        finalStack.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        finalStack.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        finalStack.bottomAnchor.constraint(equalTo: dateView.topAnchor).isActive = true
        finalStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 32.0).isActive = true
    }
    
    private func setDateConstraints(margins: UILayoutGuide) {
        dateView.topAnchor.constraint(equalTo: finalStack.bottomAnchor).isActive = true
        dateView.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        dateView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        dateView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        dateView.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
    }
}
