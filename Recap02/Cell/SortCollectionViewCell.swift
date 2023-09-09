//
//  SortCollectionViewCell.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/09.
//

import UIKit
import BaseKit
import SnapKit

final class SortCollectionViewCell: BaseCollectionViewCell<SortShopping> {
    
    private lazy var nameButton = UIButton().setup { view in
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.layer.borderWidth = 1
        view.addTarget(self, action: #selector(nameButtonClicked), for: .touchUpInside)
    }
    
    private let verticalInset: CGFloat = 8
    private let horizontalInset: CGFloat = 4
    
    var nameButtonAction: ((UIButton) -> Void)?
    
    @objc func nameButtonClicked(_ sender: UIButton) {
        nameButtonAction?(sender)
    }
    
    override func configureView() {
        contentView.addSubview(nameButton)
    }
    
    override func setConstraints() {
        nameButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configCell(row: SortShopping) {
        
        nameButton.layer.borderColor = row.isSelected ? ResColors.primaryLabel.cgColor : ResColors.placeHolder.cgColor
        
        if #available(iOS 15.0, *) {
            var attString = AttributedString(row.type.title)
            attString.font = .systemFont(ofSize: 14, weight: .medium)
            attString.foregroundColor = row.isSelected ? ResColors.mainBg : ResColors.placeHolder
            var config = UIButton.Configuration.filled()
            config.attributedTitle = attString
            config.contentInsets = .init(top: verticalInset, leading: horizontalInset, bottom: verticalInset, trailing: horizontalInset)

            config.baseBackgroundColor = row.isSelected ? ResColors.primaryLabel : ResColors.mainBg
            nameButton.configuration = config
        } else {
            nameButton.backgroundColor = row.isSelected ? ResColors.primaryLabel : ResColors.mainBg
            nameButton.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            nameButton.setTitle(row.type.title, for: .normal)
            nameButton.setTitleColor(row.isSelected ? ResColors.mainBg : ResColors.placeHolder, for: .normal)
            nameButton.contentEdgeInsets = .init(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        }
        
    }
}
