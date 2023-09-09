//
//  SearchVC.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/07.
//

import UIKit
import BaseKit
import Toast


final class SearchVC: BaseViewController<SearchView> {
    
    private let repository = ProductRepository()
    private var page = 1
    private var sortType: ShoppingSortType = .accuracy
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.searchVCDelegate = self
        navigationItem.title = ResStrings.NavigationBar.search
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ResColors.primaryLabel]
    }
    
    private func search(page: Int, query: String, sort: ShoppingSortType) {
        // 터치 이벤트 막기
        self.view.isUserInteractionEnabled = false
        repository.search(page: page, query: query, sort: sort) { [weak self] response, isSuccess in
            if isSuccess {
                guard let response else {
                    self?.mainView.emptyLabel.text = ResStrings.Guide.searchResultEmpty
                    self?.mainView.searchProducts.removeAll()
                    return
                }
                print(response)
                if response.items.isEmpty {
                    self?.mainView.emptyLabel.text = ResStrings.Guide.searchResultEmpty
                }
                self?.mainView.searchProducts.append(contentsOf: response.items)
                
            } else {
                self?.showToast(message: ResStrings.Guide.searchFail)
            }
            
            self?.view.isUserInteractionEnabled = true
        }
    }
    
    override func configureView() {
        
    }
    
    
}

extension SearchVC: SearchVCProtocol {
    func searchBarCancelClicked(_ searchBar: UISearchBar) {
        mainView.emptyLabel.text = ResStrings.Guide.searchDefaultGuide
        searchBar.searchTextField.text = nil
        mainView.searchProducts.removeAll()
    }
    
    func searchBarSearchClicked(_ searchBar: UISearchBar) {
        page = 1
        search(page: page, query: searchBar.searchTextField.text!, sort: sortType)
        searchBar.resignFirstResponder()
    }
    
    func sortClicked(sortButton: UIButton) {
        for (index, sort) in mainView.shoppingSorts.enumerated() {
            if sortButton.titleLabel!.text == sort.type.title {
                if !sort.isSelected {
                    mainView.shoppingSorts[index] = sort.copy(isSelected: true)
                    sortType = sort.type
                }
            } else {
                mainView.shoppingSorts[index] = sort.copy(isSelected: false)
            }
        }
    }
    
}

