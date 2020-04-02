//
//  HomeRequestCell.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 3/31/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class HomeRequestCell: UITableViewCell {
    
    var title: String?
    var profileImage: UIImage?
    var authorName: String?
    var authorHeadline: String?
    var dateInfo: String?
    
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
        imageView.backgroundColor = UIColor(named: ColorNames.mainColor)
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
    
    let authorStack = UIStackView()
    let finalStack = UIStackView()
    
    var dateView : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 12.0)
        label.textColor = UIColor(named: ColorNames.mainColor)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(titleView)
        self.addSubview(dateView)
        
        let margins = self.layoutMarginsGuide
        
        setTitleConstraints(margins: margins)
        
        setupAuthorStack(margins: margins)
        
        setDateConstraints(margins: margins)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if let title = title {
            titleView.text = title
        }
        
        if let profileImage = profileImage {
            profileImageView.image = profileImage
        }
                
        if let authorName = authorName {
            authorNameView.text = authorName
        }
        
        if let authorHeadline = authorHeadline {
            authorHeadlineView.text = authorHeadline
        }
        
        if let dateInfo = dateInfo {
            dateView.text = dateInfo
        }
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
    }
    
    func setTitleConstraints(margins: UILayoutGuide) {
        titleView.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        titleView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        titleView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        titleView.heightAnchor.constraint(greaterThanOrEqualToConstant: 30.0).isActive = true
    }
    
    func setupAuthorStack(margins: UILayoutGuide) {
        // MARK: Sets up the two labels for the author: name and headline
        authorNameView.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
//        authorHeadlineView.heightAnchor.constraint(equalToConstant: 15.0).isActive = true
        
        authorStack.axis = .vertical
        
        authorStack.addArrangedSubview(authorNameView)
        authorStack.addArrangedSubview(authorHeadlineView)
        authorStack.translatesAutoresizingMaskIntoConstraints = false
        
        authorStack.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        self.addSubview(authorStack)

        // MARK: Sets up the entire stack for the author: profile image + authorStack
        finalStack.axis = .horizontal
        finalStack.spacing = 5.0
        
        profileImageView.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 35.0).isActive = true
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
        
        finalStack.addArrangedSubview(profileImageView)
        finalStack.addArrangedSubview(authorStack)
        finalStack.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(finalStack)
        
        finalStack.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        finalStack.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        finalStack.topAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        finalStack.bottomAnchor.constraint(equalTo: dateView.topAnchor).isActive = true
        finalStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 32.0).isActive = true
    }
    
    func setDateConstraints(margins: UILayoutGuide) {
        dateView.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        dateView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        dateView.topAnchor.constraint(equalTo: finalStack.bottomAnchor).isActive = true
        dateView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        dateView.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
    }
}
