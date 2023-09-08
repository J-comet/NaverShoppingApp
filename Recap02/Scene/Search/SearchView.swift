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
    
    private lazy var searchBar = ShoppingSearchBar().setup { view in
        view.delegate = self
    }
    
    private lazy var productCollectionView = ProductCollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).setup { view in
        view.delegate = self
        view.dataSource = self
    }
    
    weak var delegate: SearchVCProtocol?
    
    override func configureView() {
        addSubview(searchBar)
        addSubview(productCollectionView)
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(ResDimens.defaultHorizontalMargin)
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalTo(searchBar)
        }
    }
}

extension SearchView: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchBarCancelClicked(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        delegate?.searchBarSearchClicked(searchBar)
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        // 실시간 검색 기능
//    }
}

extension SearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = .brown
        cell.layer.cornerRadius = 10.0
        cell.configCell(row: "1")
        return cell
    }
}
