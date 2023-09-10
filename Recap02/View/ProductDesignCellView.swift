//
//  ProductDesignCellView.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/10.
//

import UIKit
import BaseKit
import SkeletonView
import SnapKit

class ProductDesignCellView: BaseView {
    
    private let ImageContainerView = UIView(frame: .zero)
    
    let thumbImageView = UIImageView(frame: .zero).setup { view in
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
    }
    
    private let opacityView = UIView().setup { view in
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        view.backgroundColor = .black.withAlphaComponent(0.1)
    }
    
    lazy var heartCircleView = CircleView().setup { view in
        view.backgroundColor = ResColors.primaryLabel
    }
    
    let emptyHeartImageView = UIImageView(frame: .zero).setup { view in
        view.tintColor = ResColors.mainBg
        view.image = UIImage(systemName: "heart")
        view.isHidden = true
    }
    
    let fillHeartImageView = UIImageView(frame: .zero).setup { view in
        view.tintColor = ResColors.mainBg
        view.image = UIImage(systemName: "heart.fill")
        view.isHidden = true
    }
    
    private let labelContainerView = UIView()
    
    let mallNameLabel = UILabel().setup { view in
        view.textColor = ResColors.placeHolder
        view.font = .systemFont(ofSize: 12, weight: .medium)
    }
    
    let titleLabel = UILabel().setup { view in
        view.font = .systemFont(ofSize: 13, weight: .medium)
        view.textColor = ResColors.primaryLabel
        view.numberOfLines = 2
    }
    
    let priceLabel = UILabel().setup { view in
        view.font = .systemFont(ofSize: 15, weight: .bold)
        view.textColor = ResColors.primaryLabel
    }
    
    override func configureView() {
        self.isSkeletonable = true
        ImageContainerView.isSkeletonable = true
        labelContainerView.isSkeletonable = true
        mallNameLabel.isSkeletonable = true
        titleLabel.isSkeletonable = true
        priceLabel.isSkeletonable = true
        mallNameLabel.lastLineFillPercent = 0  // 0 으로 설정해서 스켈레톤뷰 안보이게 설정
    
        ImageContainerView.skeletonCornerRadius = 10
        mallNameLabel.linesCornerRadius = 5
        titleLabel.linesCornerRadius = 5
        priceLabel.linesCornerRadius = 5
        
        self.addSubview(ImageContainerView)
        ImageContainerView.addSubview(thumbImageView)
        ImageContainerView.addSubview(opacityView)
        ImageContainerView.addSubview(heartCircleView)
        heartCircleView.addSubview(emptyHeartImageView)
        heartCircleView.addSubview(fillHeartImageView)
        self.addSubview(labelContainerView)
        labelContainerView.addSubview(mallNameLabel)
        labelContainerView.addSubview(titleLabel)
        labelContainerView.addSubview(priceLabel)
    }
    
    override func setConstraints() {
        ImageContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.7)
        }
        
        thumbImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        opacityView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        heartCircleView.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview().inset(8)
            make.size.equalTo(40)
        }
        
        emptyHeartImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        fillHeartImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        labelContainerView.snp.makeConstraints { make in
            make.top.equalTo(ImageContainerView.snp.bottom).offset(5)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        mallNameLabel.setContentHuggingPriority(.required, for: .vertical)
        titleLabel.setContentHuggingPriority(.required, for: .vertical)
        priceLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
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
}
