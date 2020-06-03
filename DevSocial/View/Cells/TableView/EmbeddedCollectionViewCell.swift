//
//  EmbeddedCollectionViewCell.swift
//  DevSocial
//
//  Created by Jake Correnti on 6/2/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class EmbeddedCollectionViewCell: UITableViewCell {
	
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
	
	lazy var collectionView: UICollectionView = {
		let layout = UICollectionViewFlowLayout()
		let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
		view.backgroundColor = .systemBackground
		view.dataSource = self
		view.delegate = self
		layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
		view.register(CapsuleCell.self, forCellWithReuseIdentifier: Cells.capsuleCell)
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
		addSubview(collectionView)
		collectionView.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			collectionView.topAnchor.constraint(equalTo: topAnchor),
			collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
			collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
			collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
			collectionView.heightAnchor.constraint(equalToConstant: 125)
		])
    }
}

