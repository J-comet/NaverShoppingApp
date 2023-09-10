//
//  SearchVC.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/07.
//

import UIKit
import BaseKit
import RealmSwift
import SkeletonView
import Toast


final class SearchVC: BaseViewController<SearchView> {
    
    private let productRepository = ProductRepository()
    private let favoriteProductRepository = FavoriteProductRepository()
    private var page = 1
    private var sortType: ShoppingSortType = .accuracy
    
    private var searchText = ""  // 당겨서 새로고침할 때 사용자가 텍스트를 지우고 새로고침한 경우 이전에 검색한 내용으로 새로고침 기능 실행
    
    private var notificationToken: NotificationToken?
    private var favoriteProducts: Results<FavoriteProduct>?
    
    deinit {
        // realm 노티피케이션 제거
        notificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteProductRepository.printFileURL()
    }
    
    override func configureView() {
        mainView.searchVCDelegate = self
        let mainViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(mainViewTapped))
        mainView.addGestureRecognizer(mainViewTapGesture)
        navigationItem.title = ResStrings.NavigationBar.search
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ResColors.primaryLabel]
        
        let realmProducts = favoriteProductRepository.fetch(objType: FavoriteProduct.self)
        realmResultsObserve(tasks: realmProducts)
    }
    
    // realm 값 변화 옵저빙
    // realm 에 데이터 추가될 때마다 기존 서버에서 불러온 데이터와 동기화
    private func realmResultsObserve(tasks: Results<FavoriteProduct>?) {
        
        guard let tasks else { return }
        
        // observe
        notificationToken = tasks.observe { [weak self] changes in
            
            guard let self else { return }
            
            switch changes {
            case .initial:
                self.favoriteProducts = tasks
                //MARK: 최초 실행시 검색값이 없으므로 search() 함수에서 likeStatusCheckItems 로 검사하도록 수정
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed.
                print("Deleted indices: ", deletions)
                print("Inserted indices: ", insertions)
                print("Modified modifications: ", modifications)
                self.favoriteProducts = tasks
                for favoriteProduct in tasks {
                    for (index,product) in mainView.searchProducts.enumerated() {
                        if favoriteProduct.productID == product.productID {
                            print("=========== ", product.title)
                            mainView.searchProducts[index] = product.copy(isLike: true)
                            break
                        }
                    }
                }
//                self.mainView.productCollectionView.reloadData()
                
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    private func getRealmFavoriteProduct(data: ShoppingProduct) -> FavoriteProduct? {
        return favoriteProductRepository.fetchFilter(objType: FavoriteProduct.self) {
            $0.productID == data.productID
        }.first
    }
    
    private func search(page: Int, query: String, sort: ShoppingSortType, completionHandler: @escaping () -> Void) {
        productRepository.search(page: page, query: query, sort: sort) { [weak self] response, isSuccess in
            
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
                
                let result = likeStatusCheckItems(responseProducts: response.items)
                self.mainView.searchProducts.append(contentsOf: result)
                
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
    
    // realm 에 저장되어 있는 아이템과 확인
    private func likeStatusCheckItems(responseProducts: [ShoppingProduct]) -> [ShoppingProduct] {
        var items = responseProducts
        if let favoriteProducts {
            for favoriteProduct in favoriteProducts {
                for (index,product) in items.enumerated() {
                    if favoriteProduct.productID == product.productID {
                        print("=========== ", product.title)
                        items[index] = product.copy(isLike: true)
                        break
                    }
                }
            }
        }
        return items
    }
}

extension SearchVC: SearchVCProtocol {
    
    func didSelectItemAt(item: ShoppingProduct) {
        print("상세페이지로 이동", item.title)
    }
    
    func heartClicked(item: ShoppingProduct) {
        
        guard let realmFavoriteProduct = getRealmFavoriteProduct(data: item) else {
            // ADD
            let newFavoriteProduct = FavoriteProduct(
                productID: item.productID,
                title: item.title,
                link: item.link,
                image: item.image,
                lprice: item.lprice,
                mallName: item.mallName
            )
            favoriteProductRepository.create(newFavoriteProduct)
            return
        }
        
        // DELETE
        for (index,product) in mainView.searchProducts.enumerated() {
            if item.productID == product.productID {
                mainView.searchProducts[index] = product.copy(isLike: false)
                break
            }
        }
        mainView.productCollectionView.reloadData()
        favoriteProductRepository.delete(realmFavoriteProduct)
        
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
                self.mainView.productCollectionView.setContentOffset(.zero, animated: false)
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
        
        mainView.showSkeleton()
        page = 1
        search(page: page, query: searchText, sort: sortType) { [weak self] in
            self?.mainView.hideSkeleton()
            self?.mainView.productCollectionView.setContentOffset(.zero, animated: false)
        }
    }
    
    func sortClicked(sortButton: UIButton) {
        mainView.shoppingSorts.enumerated().forEach { index, sort in
            if sortButton.titleLabel!.text == sort.type.title {
                if !sort.isSelected {
                    mainView.shoppingSorts[index] = sort.copy(isSelected: true)
                    sortType = sort.type
                    
                    guard let searchText = mainView.searchBar.searchTextField.text else {
                        return
                    }
                    
                    if searchText.count > 0 {
                        mainView.searchProducts.removeAll()
                        mainView.showSkeleton()
                        page = 1
                        search(page: page, query: searchText, sort: sortType) { [weak self] in
                            self?.mainView.hideSkeleton()
                            self?.mainView.productCollectionView.setContentOffset(.zero, animated: false)
                        }
                    }
                }
            } else {
                mainView.shoppingSorts[index] = sort.copy(isSelected: false)
            }
        }
    }
    
}

