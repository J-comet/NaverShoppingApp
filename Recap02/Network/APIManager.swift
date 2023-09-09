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
    static let DISPLAY = 30
    
    private init() { }
    
    let header: HTTPHeaders = [
        "X-Naver-Client-Id": APIKey.ClientID,
        "X-Naver-Client-Secret": APIKey.ClientSecret
    ]
    
    func call<T: Codable>(
        endPoint: Endpoint,
        responseData: T.Type,
        parameters: [String:Any]? = nil,
        complete: @escaping (_ response: T?, _ isSuccess: Bool) -> (),
        end: @escaping () -> Void
    ){
        var requestParameters: Parameters = [:]
        if let parameters {
            parameters.forEach { (key, value) in
                requestParameters.updateValue(value, forKey: key)
            }
        }
        
        let url = endPoint.requestURL
        AF.request(
            url,
            method: .get,
            parameters: requestParameters,
            encoding: URLEncoding.default,
            headers: header
        )
            .validate(statusCode: 200...500)
            .responseDecodable(of: T.self) { response in
                var requestStatus: String
                switch response.result {
                case .success(let data):
                    complete(data, true)
                    requestStatus = "성공"
                case .failure(let error):
                    print(error)
                    complete(nil, false)
                    requestStatus = "실패"
                }
                print("======== \(url) ======== 호출 \(requestStatus)")
            }
    }
    
}
