//
//  DetailProductVC.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/10.
//

import UIKit
import BaseKit
import RealmSwift

final class DetailProductVC: BaseViewController<DetailProductView> {
    
    var searchProduct: ShoppingProduct?
    
    private let favoriteRepository = FavoriteProductRepository()
    private var isLike = false
    
    private var notificationToken: NotificationToken?
    
    deinit {
        // realm 노티피케이션 제거
        notificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        guard let searchProduct else { return }
        var navTitle = ""
        if searchProduct.titleValue.count > 12 {
            navTitle = searchProduct.titleValue.prefix(12) + "..."
        } else {
            navTitle = searchProduct.titleValue
        }
        
        navigationItem.title = navTitle
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ResColors.primaryLabel]
        navigationController?.navigationBar.tintColor = ResColors.primaryLabel
        
        let tasks = favoriteRepository.fetch(objType: ShoppingProduct.self)
        realmResultsObserve(tasks: tasks)
        
        mainView.reloadViewClicked = { [weak self] in
            self?.loadWebView(id: searchProduct.productId)
        }
        
        loadWebView(id: searchProduct.productId)
    }
    
    private func realmResultsObserve(tasks: Results<ShoppingProduct>?) {
        
        guard let tasks else { return }
        
        // observe
        notificationToken = tasks.observe { [weak self] changes in
            guard let self else { return }
            switch changes {
            case .initial:
                setHeartStatus()
            case .update(_, let deletions, let insertions, let modifications):
                print("상세화면 램 노티")
                setHeartStatus()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    private func setHeartStatus() {
        isLike = false
        guard let searchProduct else { return }
        let realmProduct = favoriteRepository.favoriteProductItem(productID: searchProduct.productId)
        if realmProduct != nil {
            isLike = true
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: isLike ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(heartClicked)
        )
    }
    
    @objc func heartClicked() {
        if let searchProduct {
            guard let realmFavoriteProduct = favoriteRepository.favoriteProductItem(productID: searchProduct.productId) else {
                // 좋아요 ADD
                let newFavoriteProduct = ShoppingProduct(
                    productID: searchProduct.productId,
                    title: searchProduct.titleValue,
                    image: searchProduct.image,
                    lprice: searchProduct.lprice,
                    mallName: searchProduct.mallName,
                    isLike: true
                )
                favoriteRepository.create(newFavoriteProduct)
                navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart.fill")
                return
            }
            
            // 좋아요 DELETE
            favoriteRepository.delete(realmFavoriteProduct)
            navigationItem.rightBarButtonItem?.image = UIImage(systemName: "heart")
        }
    }
    
    private func loadWebView(id: String) {
        NetworkMonitor.shared.checkNetwork {
            mainView.webView.isHidden = false
            mainView.networkErrorView.isHidden = true
            let webViewURL = URL(string:APIManager.webViewURL + id)
            guard let webViewURL else {
                showToast(message: ResStrings.Guide.notFoundWebViewURL)
                return
            }
            let request = URLRequest(url: webViewURL)
            mainView.webView.load(request)
        } failHandler: {
            mainView.webView.isHidden = true
            mainView.networkErrorView.isHidden = false
            showToast(message: ResStrings.Network.networkError, position: .top, backgroundColor: ResColors.networkError)
        }
        
    }
}
