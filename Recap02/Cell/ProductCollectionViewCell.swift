//
//  ProductCollectionViewCell.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/08.
//

import UIKit
import BaseKit

final class ProductCollectionViewCell: BaseCollectionViewCell<ShoppingProduct> {
    
    private let testLabel = UILabel().setup { view in
        view.textColor = ResColors.primaryLabel
    }
    
    override func configureView() {
        contentView.addSubview(testLabel)
    }
    
    override func setConstraints() {
        testLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configCell(row: ShoppingProduct) {
        testLabel.text = row.title
    }
}
