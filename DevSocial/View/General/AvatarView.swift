//
//  AvatarView.swift
//  DevSocial
//
//  Created by Jake Correnti on 4/3/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class AvatarView: UIView {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var user: User! {
        didSet {
            initialLabel.text = "\(user.username.first!.uppercased())"
        }
    }
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 22.5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var initialLabel: UILabel = {
        let view = UILabel()
        view.font = .boldSystemFont(ofSize: 18)
        view.textColor = .darkGray
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
        [bgView, initialLabel].forEach { addSubview($0) }
        
        constrainBgView()
        constrainInitialLabel()
    }
    
    private func constrainBgView() {
        bgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: topAnchor),
            bgView.leadingAnchor.constraint(equalTo: leadingAnchor),
            bgView.trailingAnchor.constraint(equalTo: trailingAnchor),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor),
            bgView.heightAnchor.constraint(equalToConstant: 45),
            bgView.widthAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    private func constrainInitialLabel() {
        initialLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            initialLabel.centerYAnchor.constraint(equalTo: bgView.centerYAnchor),
            initialLabel.centerXAnchor.constraint(equalTo: bgView.centerXAnchor)
        ])
    }

}
