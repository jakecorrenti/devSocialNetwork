//
//  TextViewCell.swift
//  DevSocial
//
//  Created by Mikhail Lozovyy on 4/20/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class TextViewCell: UITableViewCell {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------

    var placeholder: String? {
        didSet {
            textView.text = placeholder
            textView.textColor = UIColor(named: ColorNames.secondaryTextColor)
        }
    }
    
    var desc: String? {
        didSet {
            textView.text = desc
            textView.textColor = UIColor(named: ColorNames.primaryTextColor)
        }
    }
    
    var callBack: ((UITextView) -> ())?
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------

    lazy var textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 14, weight: .regular)
        tv.textColor = UIColor(named: ColorNames.primaryTextColor)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.textContainerInset = UIEdgeInsets.zero
        tv.textContainer.lineFragmentPadding = 0
        tv.isScrollEnabled = false
        tv.sizeToFit()
        return tv
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
        self.addSubview(textView)
        
        let margins = self.layoutMarginsGuide
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 0),
            textView.leadingAnchor.constraint(equalTo: margins.leadingAnchor, constant:  0),
            textView.trailingAnchor.constraint(equalTo: margins.trailingAnchor, constant: 0),
            textView.bottomAnchor.constraint(equalTo: margins.bottomAnchor, constant: 0)
        ])
    }
}

extension TextViewCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        callBack?(textView)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let placeholder = placeholder {
            if textView.text == placeholder {
                textView.text = ""
                textView.textColor = UIColor(named: ColorNames.primaryTextColor)
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let placeholder = placeholder {
            if textView.text == placeholder || textView.text == "" || textView.text == " " {
                textView.text = placeholder
                textView.textColor = UIColor(named: ColorNames.secondaryTextColor)
            }
        }
    }
}
