//
//  CustomSegmentedControl.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 4/20/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class CustomSegmentedControl: UIView {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var segmentedControl: UISegmentedControl = {
        let v = UISegmentedControl(items: ["Search", "Request"])
        v.selectedSegmentIndex = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
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
        self.backgroundColor = UIColor.white
        addSubview(segmentedControl)
        
        let margins = self.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant: 10),
            segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: -10),
            segmentedControl.bottomAnchor.constraint(equalTo: margins.bottomAnchor)
        ])
    }
}
