//
//  FilterShopping.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/09.
//

import Foundation

struct FilterShopping {
    var type: ShoppingFilterType
    var isSelected: Bool
    
    func copy(
        type: ShoppingFilterType? = nil,
        isSelected: Bool? = nil
    ) -> FilterShopping {
        return .init(type: type ?? self.type, isSelected: isSelected ?? self.isSelected)
    }
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
