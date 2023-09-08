//
//  FilterCollectionViewCell.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/09.
//

import UIKit
import BaseKit
import SnapKit

final class FilterCollectionViewCell: BaseCollectionViewCell<FilterShopping> {
    
    private let nameLabel = UILabel().setup { view in
        view.textColor = ResColors.primaryLabel
    }
    
    override func configureView() {
        layer.borderWidth = 1
        contentView.addSubview(nameLabel)
    }
    
    override func setConstraints() {
        nameLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configCell(row: FilterShopping) {
        nameLabel.text = row.type.title
    }
}
