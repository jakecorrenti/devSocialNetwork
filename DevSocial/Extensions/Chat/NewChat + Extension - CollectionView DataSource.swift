//
//  NewChat + Extension - CollectionView DataSource.swift
//  DevSocial
//
//  Created by Jake Correnti on 4/26/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension NewChatVC: UICollectionViewDataSource {
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		
		if selectedUsers.count == 0 {
			collectionView.setEmptyState(text: "No user selected")
		} else {
			collectionView.restorePopulatedState()
		}
		
		return selectedUsers.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.defaultCell, for: indexPath) as! NewChatUserCell
		cell.selectedUser    	= selectedUsers[indexPath.row]
		cell.backgroundColor    = .systemBackground
		cell.removeUserDelegate = self
		return cell
	}
}
