//
//  SearchView.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/07.
//

import UIKit
import BaseKit
import SnapKit

class SearchView: BaseView {
    
    override var viewBg: UIColor { ResColors.mainBg }
    
    lazy var searchBar = ShoppingSearchBar().setup { view in
        view.delegate = self
    }
    
    weak var delegate: SearchVCProtocol?
    
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

extension SearchView: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate?.cancelButtonClicked(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchButtonClicked(searchBar)
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        // 실시간 검색 기능
//    }
}
