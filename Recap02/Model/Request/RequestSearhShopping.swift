//
//  RequestSearhShopping.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/10.
//

import Foundation

struct RequestSearchShopping: Encodable {
    let query: String
    let start: Int
    let display: Int
    let sort: String
}
