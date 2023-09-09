//
//  ProductCollectionView.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/08.
//

import UIKit

final class ProductCollectionView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        self.collectionViewLayout = collectionViewLayout()
        self.showsVerticalScrollIndicator = false
        self.alwaysBounceVertical = true
        self.register(
            ProductCollectionViewCell.self,
            forCellWithReuseIdentifier: ProductCollectionViewCell.identifier
        )
    }
    
    private func collectionViewLayout() -> UICollectionViewFlowLayout {
        let spacing: CGFloat = 16
        return UICollectionViewFlowLayout().collectionViewLayout(
            itemSize: .zero,
            sectionInset: UIEdgeInsets(top: spacing, left: 0, bottom: spacing, right: 0),
            minimumLineSpacing: spacing,
            minimumInteritemSpacing: spacing)
    }
}
