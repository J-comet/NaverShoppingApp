//
//  URL+Extension.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/09.
//

import Foundation

extension URL {
    static let baseURL = "https://openapi.naver.com/v1/"
    
    static func makeEndPointString(_ endpoint: String) -> String {
        return baseURL + endpoint
    }
    
}
