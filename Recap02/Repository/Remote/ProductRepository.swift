//
//  ProductRepository.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/09.
//

import Foundation

final class ProductRepository {
    
    func search(
        start: Int,
        query: String,
        sort: ShoppingSortType = .accuracy,
        completionHandler: @escaping (_ response: ResponseSearchShopping?, _ isSuccess: Bool) -> Void
    ) {

        // 구조체로 전달
        let request = RequestSearchShopping(
            query: query,
            start: start,
            display: Endpoint.search.display,
            sort: sort.rawValue
        )
  
        APIManager.shared.call(
            endPoint: .search,
            responseData: ResponseSearchShopping.self,
            param: request
        ) { response, isSuccess in
            completionHandler(response, isSuccess)
        }
    }
    
}
