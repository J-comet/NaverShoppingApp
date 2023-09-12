//
//  ResponseSearchShopping.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/09.
//

import Foundation
import RealmSwift

// MARK: - ResponseSearchShopping
struct ResponseSearchShopping: Decodable {
    let lastBuildDate: String
    let total: Int
    let items: [ShoppingProduct]
}

// MARK: - ShoppingProduct
class ShoppingProduct: Object, Decodable {
    
    @objc dynamic var productId: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var lprice: String = ""
    @objc dynamic var mallName: String = ""
    @objc dynamic var isLike: Bool = false
    @objc dynamic var date: Date = Date()
    
    override class func primaryKey() -> String? {
        return "productId"
    }
    
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
    
    private enum CodingKeys: String, CodingKey {
        case productId
        case title, image, lprice, mallName
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.productId = try container.decode(String.self, forKey: .productId)
        self.title = try container.decode(String.self, forKey: .title)
        self.image = try container.decode(String.self, forKey: .image)
        self.lprice = try container.decode(String.self, forKey: .lprice)
        self.mallName = try container.decode(String.self, forKey: .mallName)
        self.isLike = false
        self.date = Date()
    }
    
    convenience init(
        productID: String,
        title: String,
        image: String,
        lprice: String,
        mallName: String,
        isLike: Bool
    ) {
        self.init()
        self.productId = productID
        self.title = title
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
        self.isLike = isLike
        self.date = Date()
    }

    func copy(
        productID: String? = nil,
        title: String? = nil,
        image: String? = nil,
        lprice: String? = nil,
        mallName: String? = nil,
        isLike: Bool? = nil
    ) -> ShoppingProduct {
        return .init(
            productID: productID ?? self.productId,
            title: title ?? self.title,
            image: image ?? self.image,
            lprice: lprice ?? self.lprice,
            mallName: mallName ?? self.mallName,
            isLike: isLike ?? self.isLike
        )
            
    }
}

