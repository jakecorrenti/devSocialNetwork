//
// Created by Jake Correnti on 6/2/20.
// Copyright (c) 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension EmbeddedCollectionViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 200
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.defaultCell, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}
