//
//  ProductCollectionViewCell.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/08.
//

import UIKit
import BaseKit

final class ProductCollectionViewCell: BaseCollectionViewCell<ShoppingProduct> {
    
    private let titleLabel = UILabel().setup { view in
        view.textColor = ResColors.primaryLabel
        view.numberOfLines = 2
    }
    
    override func configureView() {
        
    }
    
    override func setConstraints() {
        
    }
    
    override func configCell(row: ShoppingProduct) {
        titleLabel.text = row.title
    }
}
