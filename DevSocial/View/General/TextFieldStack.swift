//
//  TextFieldStack.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/28/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class TextFieldStack: UIView {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = 16
        view.axis = .vertical
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
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    //TODO: - Error handling
    func configure(placeholders: [String],
                   keyboardType: [UIKeyboardType] = [UIKeyboardType](),
                   isSecure: [Bool] = [Bool]() ) {
        
        placeholders.enumerated().forEach { (index, textField) in
            let view = CustomTextField()
            view.configure(placeholder: textField)
            view.keyboardType = keyboardType[index]
            view.isSecureTextEntry = isSecure[index]
            stackView.addArrangedSubview(view)
            view.isUserInteractionEnabled = true
        }
        
        stackView.heightAnchor.constraint(equalToConstant: CGFloat(placeholders.count * 40 + (16 * (placeholders.count - 1)))).isActive = true
    }

    // enables the text fields to register touches
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return true 
    }
    
}
