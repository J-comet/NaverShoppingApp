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
    
    private var searchText = ""  // 당겨서 새로고침할 때 사용자가 텍스트를 지우고 새로고침한 경우 이전에 검색한 내용으로 새로고침 기능 실행
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func search(page: Int, query: String, sort: ShoppingSortType, completionHandler: @escaping () -> Void) {
        repository.search(page: page, query: query, sort: sort) { [weak self] response, isSuccess in
            
            guard let self else {
                completionHandler()
                return
            }
            
            if isSuccess {
                guard let response else {
                    self.mainView.emptyLabel.text = ResStrings.Guide.searchResultEmpty
                    self.mainView.emptyLabel.isHidden = false
                    self.mainView.searchProducts.removeAll()
                    return
                }
//                print(response)
                if response.items.isEmpty {
                    self.mainView.emptyLabel.text = ResStrings.Guide.searchResultEmpty
                }
                self.mainView.searchProducts.append(contentsOf: response.items)
                
            } else {
                self.showToast(message: ResStrings.Guide.searchFail)
            }
            
            completionHandler()
            
            if page == 1 {
                self.mainView.removePullRefreshControllAction()
                if !self.mainView.searchProducts.isEmpty {
                    self.mainView.addPullRefreshControllAction()
                }
            }
        }
    }
    
    @objc private func mainViewTapped() {
        mainView.searchBar.resignFirstResponder()
    }
    
    override func configureView() {
        mainView.searchVCDelegate = self
        let mainViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(mainViewTapped))
        mainView.addGestureRecognizer(mainViewTapGesture)
        navigationItem.title = ResStrings.NavigationBar.search
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ResColors.primaryLabel]
    }
    
}

extension SearchVC: SearchVCProtocol {
    
    func didSelectItemAt(row: ShoppingProduct) {
        print("상세페이지로 이동", row.title)
    }
    
    func prefetchItemsAt(prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if mainView.searchProducts.count - 1 == indexPath.item && page < APIManager.limitPage {
                LoadingIndicator.show()
                page += 1
                search(page: page, query: searchText, sort: sortType) {
                    LoadingIndicator.hide()
                }
            }
        }
    }
    
    func refreshPull(refreshControl: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) { [weak self] in
            guard let self, let searchBarText = self.mainView.searchBar.searchTextField.text else {
                return
            }
            
            // 서치바에 검색어가 없는 경우 바로전에 검색한 내용으로 당겨서 새로고침
            let searchText = searchBarText.isEmpty ? self.searchText : searchBarText
            self.mainView.searchBar.searchTextField.text = searchText
            
            self.page = 1
            self.search(page: page, query: searchText, sort: self.sortType) {
                refreshControl.endRefreshing()
                self.mainView.productCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
            }
        }
    }
    
    func searchBarCancelClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = nil
        searchText = ""
        mainView.emptyLabel.text = ResStrings.Guide.searchDefaultGuide
        mainView.searchProducts.removeAll()
        mainView.removePullRefreshControllAction()
    }
    
    func searchBarSearchClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        mainView.searchProducts.removeAll()
        searchText = searchBar.searchTextField.text!
        
        LoadingIndicator.show()
        page = 1
        search(page: page, query: searchText, sort: sortType) { [weak self] in
            LoadingIndicator.hide()
            self?.mainView.productCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
        }
    }
    
    func sortClicked(sortButton: UIButton) {
        for (index, sort) in mainView.shoppingSorts.enumerated() {
            if sortButton.titleLabel!.text == sort.type.title {
                if !sort.isSelected {
                    mainView.shoppingSorts[index] = sort.copy(isSelected: true)
                    sortType = sort.type
                    
                    guard let searchText = mainView.searchBar.searchTextField.text else {
                        return
                    }
                    
                    if searchText.count > 0 {
                        mainView.searchProducts.removeAll()
                        LoadingIndicator.show()
                        page = 1
                        search(page: page, query: searchText, sort: sortType) { [weak self] in
                            LoadingIndicator.hide()
                            self?.mainView.productCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                        }
                    }
                }
            } else {
                mainView.shoppingSorts[index] = sort.copy(isSelected: false)
            }
        }
    }
    
}

