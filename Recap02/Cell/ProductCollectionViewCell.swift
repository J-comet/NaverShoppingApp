//
//  ProductCommonCell.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/10.
//

import UIKit
import BaseKit
import Kingfisher
import SkeletonView
import SnapKit

final class ProductCollectionViewCell: BaseCollectionViewCell<ShoppingProduct> {
    
    private let cellView = ProductDesignCellView(frame: .zero)
    var heartClicked: ((ShoppingProduct) -> Void)?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellView.thumbImageView.image = nil
    }
    
    override func configureView() {
        self.isSkeletonable = true
        contentView.addSubview(cellView)
        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func configCell(row: ShoppingProduct) {
        let url = URL(string: row.image)
        if let url {
            cellView.thumbImageView.kf.setImage(
                with: url,
              placeholder: nil,
              options: [
                .transition(.fade(0.1))
              ],
              completionHandler: nil
            )
        }
    
        if let attributedText = row.title.attributedHtmlString {
            cellView.titleLabel.text = attributedText.string
        }
        cellView.mallNameLabel.text = "[\(row.mallName)]"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let price = Int(row.lprice)
        let result = numberFormatter.string(for: price)

        if let result {
            cellView.priceLabel.text = result
        }
        
        cellView.heartImageView.image = row.isLike ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        
        cellView.heartCircleView.onClick = { [weak self] in
            self?.heartClicked?(row)
        }
    }
}
