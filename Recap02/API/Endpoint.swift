//
//  Endpoint.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/09.
//

import Foundation

enum Endpoint {
    case search
    
    var requestURL: String {
        switch self {
        case .search:
            return URL.makeEndPointString("search/shop.json")
        }
    }
}
