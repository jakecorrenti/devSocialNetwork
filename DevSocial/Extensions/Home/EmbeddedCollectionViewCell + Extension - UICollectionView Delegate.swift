//
// Created by Jake Correnti on 6/2/20.
// Copyright (c) 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension EmbeddedCollectionViewCell: UICollectionViewDelegate {

}

extension EmbeddedCollectionViewCell: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 20, height: 20)
    }
}
