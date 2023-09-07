//
//  FavoriteView.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/07.
//

import UIKit
import BaseKit
import SnapKit

final class FavoriteView: BaseView {
    
    override var viewBg: UIColor { ResColors.mainBg }
    
    private lazy var searchBar = ShoppingSearchBar()
    
    override func configureView() {
        addSubview(searchBar)
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(ResDimens.defaultHorizontalMargin)
        }
    }
}
