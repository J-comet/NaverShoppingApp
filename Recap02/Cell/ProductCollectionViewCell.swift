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
        cellView.fillHeartImageView.isHidden = true
        cellView.emptyHeartImageView.isHidden = true
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
    
        cellView.titleLabel.text = row.titleValue
        cellView.mallNameLabel.text = row.mallNameValue
        cellView.priceLabel.text = row.priceValue
        
        if row.isLike {
            cellView.fillHeartImageView.isHidden = false
        } else {
            cellView.emptyHeartImageView.isHidden = false
        }
        
//        cellView.heartImageView.image = UIImage(systemName: row.likeImgNameValue)
        
        cellView.heartCircleView.onClick = { [weak self] in
            print(row.likeImgNameValue)
            self?.heartClicked?(row)
        }
    }
}
