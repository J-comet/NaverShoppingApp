//
//  SearchVC.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/07.
//

import UIKit
import BaseKit

final class SearchVC: BaseViewController<SearchView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.searchVCDelegate = self
        navigationItem.title = ResStrings.NavigationBar.search
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ResColors.primaryLabel]
    }
    
    override func configureView() {
        
    }
    
}

extension SearchVC: SearchVCProtocol {
    func searchBarCancelClicked(_ searchBar: UISearchBar) {
        print(#function, "취소 버튼")
    }
    
    func searchBarSearchClicked(_ searchBar: UISearchBar) {
        print(#function, "검색 버튼")
    }
    
    func filterClicked(selectedFilterButton: UIButton) {
        for (index, filter) in mainView.shoppingFilters.enumerated() {
            if selectedFilterButton.titleLabel!.text == filter.type.title {
                if !filter.isSelected {
                    mainView.shoppingFilters[index] = filter.copy(isSelected: true)
                    mainView.filterCollectionView.reloadData()
                }
            } else {
                mainView.shoppingFilters[index] = filter.copy(isSelected: false)
            }
        }
    }
   
}

