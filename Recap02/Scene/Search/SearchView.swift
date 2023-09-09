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
        view.prefetchDataSource = self
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
            view.tintColor = ResColors.loading
        }
        productCollectionView.refreshControl?.addTarget(self, action: #selector(pullRefresh), for: .valueChanged)
        
        addSubview(searchBar)
        addSubview(sortCollectionView)
        addSubview(productCollectionView)
        addSubview(emptyLabel)
    }
    
    @objc func productCellTapped() {
        // tabGesture 를 mainView 에서 사용중이라 didSelectItemAt 이 안찍혀서 터치 재정의
        print("터치 재정의")
    }
    
    @objc private func pullRefresh(_ sender: UIRefreshControl) {
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

extension SearchView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    
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
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        searchVCDelegate?.prefetchItemsAt(prefetchItemsAt: indexPaths)
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
            
            //MARK: mainView 에서 TabGesture 로 인해 터치가 안될 때 cell 터치 재정의 해주기
            //MARK: 재정의 후에 didSelectItemAt 이 다시 호출되는 것을 확인할 수 있음
            let tap = UITapGestureRecognizer(target: self, action: #selector(productCellTapped))
            cell.addGestureRecognizer(tap)
            tap.cancelsTouchesInView = false
            
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
            //MARK: mainView 에 TabGesture 로 키보드 내리는 동작때문에 didSelectItemAt 호출 X 안되는 오류 cellForItemAt 에서 터치 재정의
            print("productCollectionView 클릭")
            let row = searchProducts[indexPath.item]
            searchVCDelegate?.didSelectItemAt(row: row)
        default: print("none")
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

