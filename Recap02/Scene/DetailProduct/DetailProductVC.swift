//
//  DetailProductVC.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/10.
//

import UIKit
import BaseKit

final class DetailProductVC: BaseViewController<DetailProductView> {
    
    var searchProduct: ShoppingProduct?
    
    private let favoriteRepository = FavoriteProductRepository()
    private var isLike = false
    
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
        
        let realmProduct = favoriteRepository.favoriteProductItem(productID: searchProduct.productID)
        if realmProduct != nil {
            isLike = true
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: isLike ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(heartClicked)
        )
        
        mainView.reloadViewClicked = { [weak self] in
            self?.loadWebView(id: searchProduct.productID)
        }
        
        loadWebView(id: searchProduct.productID)
    }
    
    @objc func heartClicked() {
        if let searchProduct {
            guard let realmFavoriteProduct = favoriteRepository.favoriteProductItem(productID: searchProduct.productID) else {
                // 좋아요 ADD
                let newFavoriteProduct = FavoriteProduct(
                    productID: searchProduct.productID,
                    title: searchProduct.titleValue,
                    link: searchProduct.link,
                    image: searchProduct.image,
                    lprice: searchProduct.lprice,
                    mallName: searchProduct.mallName
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
