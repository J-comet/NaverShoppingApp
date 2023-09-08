//
//  FilterShopping.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/09.
//

import Foundation

struct FilterShopping {
    let type: ShoppingFilterType
    var isSelected: Bool
}

enum ShoppingFilterType: CaseIterable {
    case accuracy
    case date
    case highPrice
    case lowPrice
}

extension ShoppingFilterType {
    
    var title: String {
        switch self {
        case .accuracy:
            return ResStrings.ShoppingFilterType.accuracy
        case .date:
            return ResStrings.ShoppingFilterType.date
        case .highPrice:
            return ResStrings.ShoppingFilterType.highPrice
        case .lowPrice:
            return ResStrings.ShoppingFilterType.lowPrice
        }
    }
    
    
}
