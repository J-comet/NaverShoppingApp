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
    
    lazy var searchBar = ShoppingSearchBar().setup { view in
        view.delegate = self
    }
    
    lazy var productCollectionView = ProductCollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).setup { view in
        view.delegate = self
        view.dataSource = self
        view.prefetchDataSource = self
        view.register(
            FavoriteProductCollectionViewCell.self,
            forCellWithReuseIdentifier: FavoriteProductCollectionViewCell.identifier
        )
    }
    
    let emptyLabel = UILabel().setup { view in
        view.backgroundColor = ResColors.mainBg
        view.text = ResStrings.Guide.favoriteDefaultGuide
        view.font = .monospacedSystemFont(ofSize: 16, weight: .semibold)
        view.textColor = ResColors.secondaryLabel
        view.textAlignment = .center
    }
    
    weak var favoriteVCDelegate: FavoriteVCProtocol?
    
    var favoriteProducts: [FavoriteProduct] = [] {
        didSet {
            if favoriteProducts.isEmpty {
                emptyLabel.isHidden = false
            } else {
                emptyLabel.isHidden = true
                productCollectionView.reloadData()
            }
        }
    }
    
    override func configureView() {
        addSubview(searchBar)
        addSubview(productCollectionView)
        addSubview(emptyLabel)
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(ResDimens.searchBarHorizontalMargin)
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(6)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(ResDimens.defaultHorizontalMargin)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(6)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    @objc func productCellTapped() {
        // tabGesture 를 mainView 에서 사용중이라 didSelectItemAt 이 안찍혀서 터치 재정의
        print("터치 재정의")
    }
}

extension FavoriteView: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        favoriteVCDelegate?.searchBarCancelClicked(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        favoriteVCDelegate?.searchBarSearchClicked(searchBar)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // 실시간 검색 기능
        favoriteVCDelegate?.searchBarTextDidChange(textDidChange: searchText)
    }
}


extension FavoriteView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count: CGFloat = 2
        let spacing: CGFloat = 13
        let width: CGFloat = UIScreen.main.bounds.width - (spacing * (count + 1))
        return CGSize(width: width / count, height: (width / count) * 1.4)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        favoriteVCDelegate?.prefetchItemsAt(prefetchItemsAt: indexPaths)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FavoriteProductCollectionViewCell.identifier, for: indexPath) as? FavoriteProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        //MARK: mainView 에서 TabGesture 로 인해 터치가 안될 때 cell 터치 재정의 해주기
        //MARK: 재정의 후에 didSelectItemAt 이 다시 호출되는 것을 확인할 수 있음
        let tap = UITapGestureRecognizer(target: self, action: #selector(productCellTapped))
        cell.addGestureRecognizer(tap)
        tap.cancelsTouchesInView = false
        
        cell.heartClicked = { [weak self] item in
            self?.favoriteVCDelegate?.heartClicked(item: item)
        }
        cell.configCell(row: favoriteProducts[indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //MARK: mainView 에 TabGesture 로 키보드 내리는 동작때문에 didSelectItemAt 호출 X 안되는 오류 cellForItemAt 에서 터치 재정의
        print("productCollectionView 클릭")
        if !favoriteProducts.isEmpty {
            let row = favoriteProducts[indexPath.item]
            favoriteVCDelegate?.didSelectItemAt(item: row)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
