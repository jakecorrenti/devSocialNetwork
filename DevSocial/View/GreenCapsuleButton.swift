//
//  GreenCapsuleButton.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/28/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class GreenCapsuleButton: UIButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    
    private func setupUI() {
        setTitleColor(.white, for: .normal)
        layer.cornerRadius = 25 // assuming that the button height is set to 50
        layer.masksToBounds = true
        backgroundColor = UIColor(named: ColorNames.mainColor)
    }
    
    func configure(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = .boldSystemFont(ofSize: 18)
    }
}
