//
// Created by Jake Correnti on 6/2/20.
// Copyright (c) 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension EmbeddedCollectionViewCell: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let cell = collectionView.cellForItem(at: indexPath) as! CapsuleCell

		cell.contentLabel.textColor = .lightGray
		cell.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
		
		cellSelectionDelegate.handleCellSelected(indexPath: indexPath, collectionView: collectionView, embeddedCVCell: self)
	}
}

extension EmbeddedCollectionViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        //Where elements_count is the count of all your items in that
        //Collection view...
        let cellCount = data.count

        //If the cell count is zero, there is no point in calculating anything.
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth: Int = Int(flowLayout.itemSize.width) + Int(flowLayout.minimumInteritemSpacing)

            let totalCellWidth = CGFloat(cellWidth * cellCount  * (cellCount - 1))
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right

            if (totalCellWidth < contentWidth) {
                //If the number of cells that exists take up less room than the
                //collection view width... then there is an actual point to centering them.j

                //Calculate the right amount of padding to center the cells.
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsets(top: 0, left: padding, bottom: 0, right: padding)
            } else {
                //Pretty much if the number of cells that exist take up
                //more room than the actual collectionView width, there is no
                // point in trying to center them. So we leave the default behavior.
                return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
            }
        }
        return UIEdgeInsets.zero
    }
}
