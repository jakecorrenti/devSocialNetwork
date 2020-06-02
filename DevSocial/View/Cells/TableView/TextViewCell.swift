//
//  TextViewCell.swift
//  DevSocial
//
//  Created by Jake Correnti on 6/1/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class TextViewCell: UITableViewCell {

    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
	
	lazy var textView: UITextView = {
		let view = UITextView()
		view.font = .systemFont(ofSize: 15)
		view.backgroundColor = .secondarySystemBackground
		view.isScrollEnabled = false
		view.delegate = self
		return view
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
    
    func setupUI() {
        addSubview(textView)
		textView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			textView.topAnchor.constraint(equalTo: topAnchor, constant: 4.5),
			textView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
			textView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
			textView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4.5)
		])
    }
}

extension TextViewCell: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		let size = textView.bounds.size
		let newSize = textView.sizeThatFits(CGSize(width: size.width, height: CGFloat.greatestFiniteMagnitude))
        
        // Resize the cell only when cell's size is changed
        if size.height != newSize.height {
            UIView.setAnimationsEnabled(false)
            tableView?.beginUpdates()
            tableView?.endUpdates()
            UIView.setAnimationsEnabled(true)
            
			if let thisIndexPath = tableView?.indexPath(for: self) {
				tableView?.scrollToRow(at: thisIndexPath, at: .bottom, animated: false)
            }
        }
	}
}

extension UITableViewCell {
	var tableView: UITableView? {
        get {
            var table: UIView? = superview
            while !(table is UITableView) && table != nil {
                table = table?.superview
            }

            return table as? UITableView
        }
    }
}
