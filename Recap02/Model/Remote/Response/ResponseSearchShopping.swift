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
    let total: Int
    let items: [ShoppingProduct]
}

// MARK: - ShoppingProduct
struct ShoppingProduct: Codable {
    let productID: String
    let title: String
    let link: String
    let image: String
    let lprice: String
    let mallName: String
    var isLike: Bool = false
    
    var titleValue: String {
        return title.attributedHtmlString?.string ?? ""
    }
    
    var mallNameValue: String {
        return "[\(mallName)]"
    }
    
    var priceValue: String {
        return lprice.decimalFormatString
    }
    
    var likeImgNameValue: String {
        if isLike {
            return "heart.fill"
        } else {
            return "heart"
        }
    }

    enum CodingKeys: String, CodingKey {
        case productID = "productId"
        case title, link, image, lprice, mallName
    }
    
    func copy(
        productID: String? = nil,
        title: String? = nil,
        link: String? = nil,
        image: String? = nil,
        lprice: String? = nil,
        mallName: String? = nil,
        isLike: Bool? = nil
    ) -> ShoppingProduct {
        return .init(
            productID: productID ?? self.productID,
            title: title ?? self.title,
            link: link ?? self.link,
            image: image ?? self.image,
            lprice: lprice ?? self.lprice,
            mallName: mallName ?? self.mallName,
            isLike: isLike ?? self.isLike
        )
    }
}

