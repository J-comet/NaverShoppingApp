//
//  SearchView.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/07.
//

import UIKit
import BaseKit
import SnapKit

final class SearchView: BaseView {
    
    override var viewBg: UIColor { ResColors.mainBg }
    
    lazy var searchBar = ShoppingSearchBar().setup { view in
        view.delegate = self
    }

    private lazy var sortCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout().setup({ view in
            view.scrollDirection = .horizontal
            view.sectionInset = .init(top: 0, left: 2, bottom: 0, right: 6)
            view.sectionInsetReference = .fromSafeArea
            view.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        })
    ).setup { view in
        view.delegate = self
        view.dataSource = self
        view.alwaysBounceHorizontal = true
        view.showsHorizontalScrollIndicator = false
        view.isUserInteractionEnabled = true
        view.register(
            SortCollectionViewCell.self,
            forCellWithReuseIdentifier: SortCollectionViewCell.identifier
        )
    }
    
    private lazy var productCollectionView = ProductCollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).setup { view in
        view.delegate = self
        view.dataSource = self
    }
    
    let emptyLabel = UILabel().setup { view in
        view.backgroundColor = ResColors.mainBg
        view.text = ResStrings.Guide.searchDefaultGuide
        view.font = .monospacedSystemFont(ofSize: 16, weight: .semibold)
        view.textColor = ResColors.secondaryLabel
        view.textAlignment = .center
    }
    
    weak var searchVCDelegate: SearchVCProtocol?
    
    var shoppingSorts: [SortShopping] = [] {
        didSet {
            sortCollectionView.reloadData()
        }
    }
    
    var searchProducts: [ShoppingProduct] = [] {
        didSet {
            emptyLabel.isHidden = true
            productCollectionView.reloadData()
        }
    }
    
    override func configureView() {
        ShoppingSortType.allCases.enumerated().forEach { index, sortType in
            shoppingSorts.append(
                SortShopping(type: sortType, isSelected: index == 0 ? true : false)
            )
        }
        
        productCollectionView.refreshControl = UIRefreshControl().setup { view in
            view.tintColor = .systemGreen
        }
        productCollectionView.refreshControl?.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        
        addSubview(searchBar)
        addSubview(sortCollectionView)
        addSubview(productCollectionView)
        addSubview(emptyLabel)
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        searchVCDelegate?.refreshPull(refreshControl: sender)
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(ResDimens.searchBarHorizontalMargin)
        }
                
        sortCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(ResDimens.defaultHorizontalMargin)
            make.height.equalTo(38)
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sortCollectionView.snp.bottom)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(ResDimens.defaultHorizontalMargin)
        }
        
        emptyLabel.snp.makeConstraints { make in
            make.top.equalTo(sortCollectionView.snp.bottom)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
    }
    
}

extension SearchView: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchVCDelegate?.searchBarCancelClicked(searchBar)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchVCDelegate?.searchBarSearchClicked(searchBar)
    }
    
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        // 실시간 검색 기능
//    }
}

extension SearchView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView {
        case sortCollectionView: return .init(width: 1, height: 1)
        case productCollectionView:
            let count: CGFloat = 2
            let spacing: CGFloat = 10
            let width: CGFloat = UIScreen.main.bounds.width - (spacing * (count + 1))
            return CGSize(width: width / count, height: width / count)
        default: return .zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case sortCollectionView: return shoppingSorts.count
        case productCollectionView: return searchProducts.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case sortCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SortCollectionViewCell.identifier, for: indexPath) as? SortCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.nameButtonAction = { [weak self] button in
                self?.searchVCDelegate?.sortClicked(sortButton: button)
            }
            cell.configCell(row: shoppingSorts[indexPath.item])
            return cell
            
        case productCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .brown
            cell.layer.cornerRadius = 10.0
            cell.configCell(row: searchProducts[indexPath.item])
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case sortCollectionView:
            print("버튼만 있을 때는 didSelectItemAt 메서드 호출 X , 현재 클로저로 액션 전달")
        case productCollectionView:
            print("productCollectionView 클릭")
        default: print("none")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

