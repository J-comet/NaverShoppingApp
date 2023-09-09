//
//  SearchVC.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/07.
//

import UIKit
import BaseKit

final class SearchVC: BaseViewController<SearchView> {
    
    private let repository = ProductRepository()
    private var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.searchVCDelegate = self
        navigationItem.title = ResStrings.NavigationBar.search
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ResColors.primaryLabel]
    }
    
    private func search(page: Int, query: String) {
        repository.search(page: page, query: query) { [weak self] response, isSuccess in
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
                print("오류 발생")
            }
        } endHandler: {
            print("인디케이터 종료시키기")
        }
    }
    
    override func configureView() {
        
    }
    
    
}

extension SearchVC: SearchVCProtocol {
    func searchBarCancelClicked(_ searchBar: UISearchBar) {
        print(#function, "취소 버튼")
        mainView.emptyLabel.text = ResStrings.Guide.searchDefaultGuide
        searchBar.searchTextField.text = nil
        mainView.searchProducts.removeAll()
    }
    
    func searchBarSearchClicked(_ searchBar: UISearchBar) {
        print(#function, "검색 버튼")
        guard let text = searchBar.searchTextField.text else { return }
        
        if text.isEmpty {
            print("검색어를 입력해주세요")
            return
        }
        
        page = 1
        search(page: page, query: text)
        searchBar.endEditing(true)
    }
    
    func sortClicked(sortButton: UIButton) {
        for (index, sort) in mainView.shoppingSorts.enumerated() {
            if sortButton.titleLabel!.text == sort.type.title {
                if !sort.isSelected {
                    mainView.shoppingSorts[index] = sort.copy(isSelected: true)
                }
            } else {
                mainView.shoppingSorts[index] = sort.copy(isSelected: false)
            }
        }
    }
    
}

