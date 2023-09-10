//
//  DetailProductVC.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/10.
//

import UIKit
import BaseKit

final class DetailProductVC: BaseViewController<DetailProductView> {
    
    var productID: String?
    var productTitle: String?
    
    private let favoriteRepostiroy = FavoriteProductRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func configureView() {
        guard let productID, let productTitle else { return }
        
        var navTitle = ""
        if productTitle.count > 10 {
            navTitle = productTitle.prefix(12) + "..."
        } else {
            navTitle = productTitle
        }
        
        navigationItem.title = navTitle
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ResColors.primaryLabel]
        
        let product = favoriteRepostiroy.fetchFilter(objType: FavoriteProduct.self){
            $0.productID.equals(productID)
        }.first
        
        var heartImg = UIImage(systemName: "heart")
        if product != nil {
            heartImg = UIImage(systemName: "heart.fill")
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: heartImg,
            style: .plain,
            target: self,
            action: #selector(heartClicked)
        )
        
        self.navigationController?.navigationBar.tintColor = ResColors.primaryLabel
    }
    
    @objc func heartClicked() {
        print("1234")
    }
}
