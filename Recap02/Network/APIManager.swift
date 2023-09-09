//
//  APIManager.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/09.
//

import Foundation
import Alamofire

class APIManager {
    static let shared = APIManager()
    private init() { }
    
    let header: HTTPHeaders = [
        "X-Naver-Client-Id": APIKey.ClientID,
        "X-Naver-Client-Secret": APIKey.ClientSecret
    ]
    
    
}
