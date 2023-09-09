//
//  ProductCollectionViewCell.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/08.
//

import UIKit
import BaseKit
import Kingfisher
import SnapKit

final class ProductCollectionViewCell: BaseCollectionViewCell<ShoppingProduct> {
    
    private let thumbImageView = UIImageView(frame: .zero).setup { view in
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }
    
    private let opacityView = UIView().setup { view in
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .black.withAlphaComponent(0.1)
    }
    
    private lazy var heartCircleView = CircleView().setup { view in
        view.backgroundColor = ResColors.primaryLabel
        view.onClick = {
            print("하트 클릭")
        }
    }
    
    private let heartImageView = UIImageView(frame: .zero).setup { view in
        view.tintColor = ResColors.mainBg
        view.image = UIImage(systemName: "heart")
    }
    
    private let labelContainerView = UIView()
    
    private let mallNameLabel = UILabel().setup { view in
        view.textColor = ResColors.placeHolder
        view.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    private let titleLabel = UILabel().setup { view in
        view.font = .systemFont(ofSize: 13, weight: .medium)
        view.textColor = ResColors.primaryLabel
        view.numberOfLines = 2
    }
    
    private let priceLabel = UILabel().setup { view in
        view.font = .systemFont(ofSize: 15, weight: .bold)
        view.textColor = ResColors.primaryLabel
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = nil
    }
    
    override func configureView() {
        contentView.addSubview(thumbImageView)
        contentView.addSubview(opacityView)
        contentView.addSubview(heartCircleView)
        heartCircleView.addSubview(heartImageView)
        contentView.addSubview(labelContainerView)
        labelContainerView.addSubview(mallNameLabel)
        labelContainerView.addSubview(titleLabel)
        labelContainerView.addSubview(priceLabel)
    }
    
    override func setConstraints() {
        thumbImageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        opacityView.snp.makeConstraints { make in
            make.edges.equalTo(thumbImageView)
        }
        
        heartCircleView.snp.makeConstraints { make in
            make.trailing.equalTo(thumbImageView.snp.trailing).inset(8)
            make.bottom.equalTo(thumbImageView.snp.bottom).inset(8)
            make.size.equalTo(40)
        }
        
        heartImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        labelContainerView.snp.makeConstraints { make in
            make.top.equalTo(thumbImageView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        mallNameLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.horizontalEdges.equalToSuperview().inset(2)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom)
            make.horizontalEdges.equalTo(mallNameLabel)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.equalTo(titleLabel)
            make.bottom.lessThanOrEqualToSuperview()
        }
    }
    
    override func configCell(row: ShoppingProduct) {
        let url = URL(string: row.image)
        if let url {
            thumbImageView.kf.setImage(
                with: url,
              placeholder: nil,
              options: [
                .transition(.fade(0.1))
              ],
              completionHandler: nil
            )
        }
    
        if let attributedText = row.title.attributedHtmlString {
            titleLabel.text = attributedText.string
        }
        mallNameLabel.text = "[\(row.mallName)]"
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let price = Int(row.lprice)
        let result = numberFormatter.string(for: price)

        if let result {
            priceLabel.text = result
        }
    }
}
