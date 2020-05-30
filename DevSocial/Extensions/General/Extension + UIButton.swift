//
//  Extension + UIButton.swift
//  DevSocial
//
//  Created by Jake Correnti on 5/30/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension UIButton {
	func pulsate() {
		let pulse = CASpringAnimation(keyPath: "transform.scale")
		pulse.duration = 0.25
		pulse.fromValue = 0.95
		pulse.toValue = 1.0
		pulse.initialVelocity = 0.5
		pulse.damping = 1.0
		layer.add(pulse, forKey: nil)
	}
}
