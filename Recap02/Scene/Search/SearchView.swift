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
    
    private lazy var searchBar = ShoppingSearchBar().setup { view in
        view.delegate = self
    }

    private lazy var filterCollectionView = UICollectionView(
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
            FilterCollectionViewCell.self,
            forCellWithReuseIdentifier: FilterCollectionViewCell.identifier
        )
    }
    
    private lazy var productCollectionView = ProductCollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewLayout()
    ).setup { view in
        view.delegate = self
        view.dataSource = self
    }
    
    weak var searchVCDelegate: SearchVCProtocol?
    
    private var shoppingFilters: [FilterShopping] = []
    
    override func configureView() {
        ShoppingFilterType.allCases.enumerated().forEach { index, filterType in
            shoppingFilters.append(
                FilterShopping(type: filterType, isSelected: index == 0 ? true : false)
            )
        }
        
        addSubview(searchBar)
        addSubview(filterCollectionView)
        addSubview(productCollectionView)
    }
    
    override func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview().inset(ResDimens.searchBarHorizontalMargin)
        }
                
        filterCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(ResDimens.defaultHorizontalMargin)
            make.height.equalTo(38)
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterCollectionView.snp.bottom)
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(ResDimens.defaultHorizontalMargin)
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
        case filterCollectionView: return .init(width: 1, height: 1)
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
        case filterCollectionView: return shoppingFilters.count
        case productCollectionView: return 20
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case filterCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.identifier, for: indexPath) as? FilterCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.nameButtonAction = { [weak self] button in
                
                guard let filters = self?.shoppingFilters else { return }
                
                for (index, filter) in filters.enumerated() {
                    if button.titleLabel!.text == filter.type.title {
                        print(filter.type.title)
                        if !filter.isSelected {
                            self!.shoppingFilters[index] = FilterShopping(type: filter.type, isSelected: true)
                            self?.filterCollectionView.reloadData()
                        }
                    } else {
                        self!.shoppingFilters[index] = FilterShopping(type: filter.type, isSelected: false)
                    }
                }
                
                self?.searchVCDelegate?.filterClicked(
                    row: (self?.shoppingFilters[indexPath.item])!
                )
            }
            cell.configCell(row: shoppingFilters[indexPath.item])
            return cell
            
        case productCollectionView:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as? ProductCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.backgroundColor = .brown
            cell.layer.cornerRadius = 10.0
            cell.configCell(row: "1")
            return cell
            
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case filterCollectionView:
            print("버튼만 있을 때는 didSelectItemAt 메서드 호출 X , 현재 클로저로 액션 전달")
            
        case productCollectionView:
            print("111")
        default: print("none")
        }
    }
}

