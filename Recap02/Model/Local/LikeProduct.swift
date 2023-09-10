//
//  LikeProduct.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/10.
//

import Foundation
import RealmSwift

class LikeProduct: Object {
       
    @Persisted(primaryKey: true) var productID: String
    @Persisted var title: String
    @Persisted var link: String
    @Persisted var image: String
    @Persisted var lprice: String
    @Persisted var mallName: String
    
    convenience init(
        productID: String,
        title: String,
        link: String,
        image: String,
        lprice: String,
        mallName: String
    ) {
        self.init()
        self.productID = productID
        self.title = title
        self.link = link
        self.image = image
        self.lprice = lprice
        self.mallName = mallName
    }

}
