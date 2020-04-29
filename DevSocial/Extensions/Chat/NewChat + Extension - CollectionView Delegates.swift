//
//  NewChat + Extension - CollectionView Delegates.swift
//  DevSocial
//
//  Created by Jake Correnti on 4/26/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension NewChatVC: UICollectionViewDelegateFlowLayout {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize(width: 131, height: 130)
	}


}

extension NewChatVC: UICollectionViewDelegate {

}
