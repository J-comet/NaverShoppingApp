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
    private var total = 0
    private var startIndex = 0
    
    private var searchText = ""  // 당겨서 새로고침할 때 사용자가 텍스트를 지우고 새로고침한 경우 이전에 검색한 내용으로 새로고침 기능 실행
    
    private var notificationToken: NotificationToken?
    private var favoriteProducts: Results<ShoppingProduct>?
    
    deinit {
        // realm 노티피케이션 제거
        notificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteProductRepository.printFileURL()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.searchBar.resignFirstResponder()
    }
    
    override func configureView() {
        mainView.searchVCDelegate = self
        let mainViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(mainViewTapped))
        mainView.addGestureRecognizer(mainViewTapGesture)
        navigationItem.title = ResStrings.NavigationBar.search
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ResColors.primaryLabel]
        
        let realmProducts = favoriteProductRepository.fetch(objType: ShoppingProduct.self)
        realmResultsObserve(tasks: realmProducts)
    }
    
    // realm 값 변화 옵저빙
    // realm 에 데이터 추가될 때마다 기존 서버에서 불러온 데이터와 동기화
    private func realmResultsObserve(tasks: Results<ShoppingProduct>?) {
        
        guard let tasks else { return }
        
        // observe
        notificationToken = tasks.observe { [weak self] changes in
            
            guard let self else { return }
            
            switch changes {
            case .initial:
                //MARK: 최초 실행시 검색값이 없으므로 search() 함수에서 likeStatusCheckItems 로 검사하도록 수정
                self.favoriteProducts = tasks
            case .update(_, let deletions, let insertions, let modifications):
                print("업데이트 되어따")
                self.favoriteProducts = tasks
                mainView.searchProducts = likeStatusCheckItems(responseProducts: mainView.searchProducts)
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    private func search(page: Int, query: String, sort: ShoppingSortType, completionHandler: @escaping () -> Void) {
        startIndex = ((page - 1) * Endpoint.search.display) + 1
        print("startIndex = \(startIndex)")
        productRepository.search(start: startIndex, query: query, sort: sort) { [weak self] response, isSuccess in
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
                total = response?.total ?? 0
                print("total = \(total)")
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
            for (index,product) in items.enumerated() {
                items[index] = product.copy(isLike: false)
                
                for favoriteProduct in favoriteProducts {
                    if favoriteProduct.productId == product.productId {
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
        let vc = DetailProductVC()
        vc.searchProduct = item
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func heartClicked(item: ShoppingProduct) {
        // 페이징 이후 하트 클릭하면 하트색이 안바뀌는 오류 발생
        //  => 기존 하나의 UIImageView 에서 UIImage 값 변경 -> 두개의 UIImageView (꽉찬 하트, 일반 하트) 로 Hidden 처리로 오류 수정
        guard let realmFavoriteProduct = favoriteProductRepository.favoriteProductItem(productID: item.productId) else {
            // ADD
            let newFavoriteProduct = ShoppingProduct(
                productID: item.productId,
                title: item.titleValue,
                image: item.image,
                lprice: item.lprice,
                mallName: item.mallName,
                isLike: true
            )
            favoriteProductRepository.create(newFavoriteProduct)
            return
        }
        
        // DELETE
        for (index,product) in mainView.searchProducts.enumerated() {
            if item.productId == product.productId {
                mainView.searchProducts[index] = product.copy(isLike: false)
                break
            }
        }
        favoriteProductRepository.delete(realmFavoriteProduct)
    }
    
    func prefetchItemsAt(prefetchItemsAt indexPaths: [IndexPath]) {
        
        // 검색갯수가 1000개 초과일 때는 1000개로 제한
        let limit = total > Endpoint.search.limitStart ? Endpoint.search.limitStart : total
        
        for indexPath in indexPaths {
            if mainView.searchProducts.count - 1 == indexPath.item && startIndex < limit {
                LoadingIndicator.show()
                page += 1
                search(page: page, query: searchText, sort: sortType) {
                    LoadingIndicator.hide()
                }
            }
        }
    }
    
    func refreshPull(refreshControl: UIRefreshControl) {
        NetworkMonitor.shared.checkNetwork {
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
        } failHandler: {
            refreshControl.endRefreshing()
            showToast(message: ResStrings.Network.networkError, position: .top, backgroundColor: ResColors.networkError)
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
        NetworkMonitor.shared.checkNetwork {
            searchBar.resignFirstResponder()
            mainView.searchProducts.removeAll()
            searchText = searchBar.searchTextField.text!
            
            mainView.showSkeleton()
            page = 1
            search(page: page, query: searchText, sort: sortType) { [weak self] in
                self?.mainView.hideSkeleton()
                self?.mainView.productCollectionView.setContentOffset(.zero, animated: false)
            }
            
        } failHandler: {
            showToast(message: ResStrings.Network.networkError, position: .top, backgroundColor: ResColors.networkError)
        }
    }
    
    func sortClicked(sortButton: UIButton) {
        guard let searchFieldText = mainView.searchBar.searchTextField.text else {
            return
        }
        
        let searchContent = searchFieldText.count > 0 ? searchFieldText : self.searchText

        if searchContent.count > 0 {
            NetworkMonitor.shared.checkNetwork {
                mainView.searchBar.resignFirstResponder()
                mainView.shoppingSorts.enumerated().forEach { index, sort in
                    if sortButton.titleLabel!.text == sort.type.title {
                        if !sort.isSelected {
                            mainView.shoppingSorts[index] = sort.copy(isSelected: true)
                            sortType = sort.type
                        }
                    } else {
                        mainView.shoppingSorts[index] = sort.copy(isSelected: false)
                    }
                }
                
                mainView.searchProducts.removeAll()
                mainView.showSkeleton()
                page = 1
                search(page: page, query: searchText, sort: sortType) { [weak self] in
                    self?.mainView.hideSkeleton()
                    self?.mainView.productCollectionView.setContentOffset(.zero, animated: false)
                }
            } failHandler: {
                showToast(message: ResStrings.Network.networkError, position: .top, backgroundColor: ResColors.networkError)
            }

        } else {
            mainView.shoppingSorts.enumerated().forEach { index, sort in
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
    
}

