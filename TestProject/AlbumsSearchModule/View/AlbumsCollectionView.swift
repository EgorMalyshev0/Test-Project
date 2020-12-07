//
//  AlbumsCollectionView.swift
//  TestProject
//
//  Created by Egor Malyshev on 05.12.2020.
//

import UIKit

class AlbumsCollectionView: UICollectionView {
    
    //MARK: - Class properties

    let itemsPerRow: CGFloat = 2
    let minimumItemSpacing: CGFloat = 20
    let minimumLineSpacing: CGFloat = 20
    let sectionInsets = UIEdgeInsets(top: 15, left: 20, bottom: 15, right: 20)
    
    // This value is needed to count cell's height correctly. (In fact it's the fixed height of stackView in cell)
    let fixedValue: CGFloat = 40
        
    //MARK: - Class methods
    
    func countSize() -> CGSize {
        let width = self.frame.width
        let paddingSpace = sectionInsets.left + sectionInsets.right + minimumItemSpacing * (itemsPerRow - 1)
        let availableWidth = width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let size = CGSize(width: widthPerItem, height: widthPerItem + fixedValue)
        return size
    }
}
