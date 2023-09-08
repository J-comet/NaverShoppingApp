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
        let count: CGFloat = 2
        let spacing: CGFloat = 10
        let width: CGFloat = UIScreen.main.bounds.width - (spacing * (count + 1))
        
        return UICollectionViewFlowLayout().collectionViewLayout(
            itemSize: CGSize(width: width / count, height: width / count),
            sectionInset: .zero,
            minimumLineSpacing: spacing + (spacing / 2),
            minimumInteritemSpacing: spacing)
    }
}
