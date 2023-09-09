//
//  ResponseSearchShopping.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/09.
//

import Foundation

// MARK: - ResponseSearchShopping
struct ResponseSearchShopping: Codable {
    let lastBuildDate: String
    let items: [ShoppingProduct]
}

// MARK: - ShoppingProduct
struct ShoppingProduct: Codable {
    let title: String
    let link: String
    let image: String
    let lprice, hprice, mallName, productID: String
    let productType, brand, maker: String
    let category1, category2, category3, category4: String

    enum CodingKeys: String, CodingKey {
        case title, link, image, lprice, hprice, mallName
        case productID = "productId"
        case productType, brand, maker, category1, category2, category3, category4
    }
}

