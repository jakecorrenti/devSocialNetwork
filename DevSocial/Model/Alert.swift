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
}
