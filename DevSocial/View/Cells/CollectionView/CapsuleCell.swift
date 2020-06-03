//
// Created by Jake Correnti on 6/2/20.
// Copyright (c) 2020 Jake Correnti. All rights reserved.
//

import UIKit

class CapsuleCell: UICollectionViewCell {

    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------

    var content: String! {
        didSet {
            self.contentLabel.text = content
            self.layer.cornerRadius = 15
        }
    }

    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------

    lazy var contentLabel: UILabel = {
        let view = UILabel()
        view.textColor = UIColor(named: ColorNames.mainColor)
        view.font = .boldSystemFont(ofSize: 13)
        return view
    }()

    // -----------------------------------------
    // MARK: Initialization
    // -----------------------------------------

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupUI()
    }

    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------

    private func setupUI() {
        addSubview(contentLabel)
        contentLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            contentLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            contentLabel.topAnchor.constraint(equalTo: topAnchor),
            contentLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
}
