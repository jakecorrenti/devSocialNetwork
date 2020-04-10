//
//  HomePostCell.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 4/3/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class HomeSearchCell: UITableViewCell {
    
    var title: String?
    var profileImage: UIImage?
    var authorName: String?
    var authorHeadline: String?
    var desc: String?
    var dateInfo: String?
    
    var titleView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 18.0)
        label.textColor = UIColor(named: ColorNames.primaryTextColor)
        return label
    }()
    
    var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = UIColor(named: ColorNames.mainColor)
        return imageView
    }()
    
    var authorNameView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 14.0)
        label.textColor = UIColor(named: ColorNames.primaryTextColor)
        return label
    }()
    
    var authorHeadlineView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 10.0)
        label.textColor = UIColor(named: ColorNames.secondaryTextColor)
        return label
    }()
    
    var authorStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    var finalStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = 5
        return stack
    }()
    
    var descView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        textView.isSelectable = false
        textView.isScrollEnabled = false
        textView.font = UIFont(name: "Helvetica Neue", size: 12.0)
        textView.textColor = UIColor(named: ColorNames.primaryTextColor)
        textView.backgroundColor = .clear
        return textView
    }()
    
    var dateView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Helvetica Neue", size: 12.0)
        label.textColor = UIColor(named: ColorNames.mainColor)
        return label
    }()
    
    var bottomSeparatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(named: ColorNames.secondaryTextColor)?.withAlphaComponent(0.5)
        return view
    }()
    
    var smileyStack: SmileyStack = {
        let view = SmileyStack()
        view.configure(smileyNames: ["smiley_1_unselected", "smiley_2_unselected", "smiley_3_unselected", "smiley_4_unselected", "smiley_5_unselected"])
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let margins = self.layoutMarginsGuide
        
        [titleView, descView, dateView, bottomSeparatorView, smileyStack].forEach { self.addSubview($0) }
        
        setTitleConstraints(margins: margins)
        setupAuthorStack(margins: margins)
        setDescConstraints(margins: margins)
        setDateConstraints(margins: margins)
        setSeparatorConstraints()
        setSmileyConstraints(margins: margins)
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
        
        if let desc = desc {
            descView.text = desc
        }
        
        if let dateInfo = dateInfo {
            dateView.text = dateInfo
        }
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
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
        profileImageView.clipsToBounds = true
        
        
        // MARK: Setup of the entire middle stack
        finalStack.addArrangedSubview(profileImageView)
        finalStack.addArrangedSubview(authorStack)
        
        self.addSubview(finalStack)
        
        finalStack.topAnchor.constraint(equalTo: titleView.bottomAnchor).isActive = true
        finalStack.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        finalStack.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        finalStack.bottomAnchor.constraint(equalTo: descView.topAnchor).isActive = true
        finalStack.heightAnchor.constraint(greaterThanOrEqualToConstant: 32.0).isActive = true
    }
    
    private func setDescConstraints(margins: UILayoutGuide) {
        descView.topAnchor.constraint(equalTo: finalStack.bottomAnchor).isActive = true
        descView.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        descView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        descView.heightAnchor.constraint(greaterThanOrEqualToConstant: 50).isActive = true
    }
    
    private func setDateConstraints(margins: UILayoutGuide) {
        dateView.topAnchor.constraint(equalTo: descView.bottomAnchor).isActive = true
        dateView.leftAnchor.constraint(equalTo: margins.leftAnchor).isActive = true
        dateView.rightAnchor.constraint(equalTo: margins.rightAnchor).isActive = true
        dateView.heightAnchor.constraint(equalToConstant: 25.0).isActive = true
    }
    
    private func setSeparatorConstraints() {
        bottomSeparatorView.topAnchor.constraint(equalTo: dateView.bottomAnchor, constant: 5).isActive = true
        bottomSeparatorView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        bottomSeparatorView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        bottomSeparatorView.heightAnchor.constraint(equalToConstant: 1.0).isActive = true
    }
    
    private func setSmileyConstraints(margins: UILayoutGuide) {
        smileyStack.topAnchor.constraint(equalTo: bottomSeparatorView.bottomAnchor, constant: 10).isActive = true
        smileyStack.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        smileyStack.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        smileyStack.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        smileyStack.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
    }
}
