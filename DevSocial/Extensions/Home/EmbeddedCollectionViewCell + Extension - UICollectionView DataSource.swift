//
// Created by Jake Correnti on 6/2/20.
// Copyright (c) 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension EmbeddedCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return NewPartnerSearchVC.getTestData().count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.capsuleCell, for: indexPath) as! CapsuleCell
        cell.backgroundColor = UIColor(named: ColorNames.mainColor)?.withAlphaComponent(0.2)
        cell.content = NewPartnerSearchVC.getTestData()[indexPath.row]
        return cell
    }
}
