//
//  WelcomeVC.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/28/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Welcome to DevSocial"
        view.font = .boldSystemFont(ofSize: 30)
        view.textAlignment = .center
        return view
    }()
    
    lazy var welcomeImageView: UIImageView = {
        let view = UIImageView(image: UIImage(named: Images.welcomeImage))
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Find your next teammate or project to work on!"
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = .systemGray
        view.font = .boldSystemFont(ofSize: 20)
        return view
    }()
    
    lazy var welcomeSubtitleStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.welcomeImageView, self.subtitleLabel])
        view.axis = .vertical
        view.spacing = 24
        return view
    }()
    
    lazy var getStartedButton: GreenCapsuleButton = {
        let view = GreenCapsuleButton(type: .system)
        view.configure(title: "Get started")
        view.addTarget(self, action: #selector(getStartedButtonPressed), for: .touchUpInside)
        return view
    }()
    
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupUI()
        
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
        view.backgroundColor = UIColor(named: ColorNames.background)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    private func setupUI() {
        [titleLabel, welcomeSubtitleStack, getStartedButton].forEach { view.addSubview($0) }
    
        constrainTitleLabel()
        constrainWelcomeSubtitleStack()
        constrainGetStartedButton()
    }
    
    private func constrainTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func constrainWelcomeSubtitleStack() {
        welcomeSubtitleStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            welcomeSubtitleStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeSubtitleStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            welcomeSubtitleStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            welcomeSubtitleStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
            
        ])
    }
    
    private func constrainGetStartedButton() {
        getStartedButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            getStartedButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            getStartedButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            getStartedButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            getStartedButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc func getStartedButtonPressed() {
        navigationController?.pushViewController(PagingVC(), animated: true)
    }
}
