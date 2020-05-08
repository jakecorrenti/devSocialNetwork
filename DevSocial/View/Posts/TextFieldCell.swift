//
//  TextFieldCell.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 4/20/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var textField: CustomTextField = {
        let tf = CustomTextField()
        tf.backgroundColor = .clear
        tf.borderStyle = .none
        tf.configure(placeholder: "Title", keyboardType: .default, isSecure: false)
        tf.clearButtonMode = .always
        tf.font = .systemFont(ofSize: 17, weight: .semibold)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
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
        self.addSubview(textField)
        
        let margins = self.layoutMarginsGuide
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0),
            textField.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant:  0),
            textField.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0),
            textField.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0),
            textField.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
}
