//
//  ProductRepository.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/09.
//

import Foundation

class ProductRepository {
    
    func search(
        page: Int,
        query: String,
        sort: ShoppingSortType = .accuracy,
        completionHandler: @escaping (_ response: ResponseSearchShopping?, _ isSuccess: Bool) -> Void,
        endHandler: @escaping () -> Void
    ) {
        APIManager.shared.call(
            endPoint: .search,
            responseData: ResponseSearchShopping.self,
            parameters: [
                "query": query,
                "start": page,
                "display": APIManager.DISPLAY,
                "sort": sort.rawValue
            ]
        ) { response, isSuccess in
            completionHandler(response, isSuccess)
        } end: {
            endHandler()
        }
    }
    
}
