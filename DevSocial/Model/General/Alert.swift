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

    static func showTextFieldAlert(on vc: UIViewController, title: String, onCancelPressed: @escaping () -> Void, onAddPressed: @escaping (String?) -> Void) {
        let ac = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        ac.addTextField { textField in
            textField.autocorrectionType = .yes
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        let addAction = UIAlertAction(title: "Add", style: .default) { [unowned ac] _ in
            onAddPressed(ac.textFields![0].text)
        }

        [cancelAction, addAction].forEach { ac.addAction($0) }
        vc.present(ac, animated: true)
    }

}
