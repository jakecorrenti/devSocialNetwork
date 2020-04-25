//
//  Alert.swift
//  DevSocial
//
//  Created by Jake Correnti on 3/29/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

struct Alert {
    
    static func showBasicAlert(on vc: UIViewController, with title: String, message: String? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction        = UIAlertAction(title: "Ok", style: .default)
        alertController.addAction(okAction)
        vc.present(alertController, animated: true)
    }
    
    static func showFillAllFieldsAlert(on vc: UIViewController) {
        showBasicAlert(on: vc, with: "Incomplete Fields", message: "You must complete all fields int the form to continue")
    }

    static func showDeleteConfirmation(on vc: UIViewController, onDeleteSelected: @escaping () -> Void ) {
        let alertController = UIAlertController(title: "Are you sure you would like to delete this?", message: nil, preferredStyle: .actionSheet)
        let deleteAction    = UIAlertAction(title: "Delete", style: .destructive) { action in 
            onDeleteSelected()
        }
        let cancelAction    = UIAlertAction(title: "Cancel", style: .cancel)
        [deleteAction, cancelAction].forEach { alertController.addAction($0) }
        vc.present(alertController, animated: true)
    }
	
	static func showDeleteConfirmation(on vc: UIViewController, onDeleteSelected: @escaping () -> Void, onCancelSelected: @escaping () -> Void) {
		let alertController = UIAlertController(title: "Are you sure you would like to delete this?", message: nil, preferredStyle: .actionSheet)
        let deleteAction    = UIAlertAction(title: "Delete", style: .destructive) { action in
            onDeleteSelected()
        }
		let cancelAction    = UIAlertAction(title: "Cancel", style: .cancel) { action in
			onCancelSelected()
		}
        [deleteAction, cancelAction].forEach { alertController.addAction($0) }
        vc.present(alertController, animated: true)
	}
}
