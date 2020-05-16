//
//  Extension + UIViewController.swift
//  DevSocial
//
//  Created by Jake Correnti on 5/12/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

fileprivate var containerView: UIView!
fileprivate var activityIndicator = UIActivityIndicatorView(style: .large)

extension UIViewController {
	
	func showLoadingView() {
        containerView = UIView(frame: view.bounds)
        view.addSubview(containerView)
		containerView.backgroundColor = UIColor(named: ColorNames.background)
        containerView.alpha 		  = 0
        
        UIView.animate(withDuration: 0.25) {
            containerView.alpha = 0.8
        }
        containerView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
			activityIndicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
			activityIndicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        ])
		
        activityIndicator.startAnimating()
    }
    
    func dismissLoadingView() {
        DispatchQueue.main.async {
			activityIndicator.stopAnimating()
			activityIndicator.hidesWhenStopped = true
			activityIndicator.removeFromSuperview()
            containerView.removeFromSuperview()
        }
    }
}
