//
//  SmileyStack.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 4/4/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class SmileyStack: UIView {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 10
        view.axis = .horizontal
        view.distribution = .fillEqually
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
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    func configure(smileyNames: [String]) {
        smileyNames.enumerated().forEach { (index, smileyName) in
            let view = UIImageView(image: UIImage(named: smileyName))
            
            stackView.addArrangedSubview(view)
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 25).isActive = true
            view.widthAnchor.constraint(equalToConstant: 25).isActive = true
            
        }
        
        stackView.widthAnchor.constraint(equalToConstant: CGFloat((smileyNames.count * 25 ) + 40)).isActive = true
    }

}
