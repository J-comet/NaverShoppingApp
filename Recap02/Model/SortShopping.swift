//
//  SortShopping.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/09.
//

import Foundation

struct SortShopping {
    var type: ShoppingSortType
    var isSelected: Bool
    
    func copy(
        type: ShoppingSortType? = nil,
        isSelected: Bool? = nil
    ) -> SortShopping {
        return .init(type: type ?? self.type, isSelected: isSelected ?? self.isSelected)
    }
}

enum ShoppingSortType: CaseIterable {
    case accuracy
    case date
    case highPrice
    case lowPrice
}

extension ShoppingSortType {
    
    var title: String {
        switch self {
        case .accuracy:
            return ResStrings.ShoppingSortType.accuracy
        case .date:
            return ResStrings.ShoppingSortType.date
        case .highPrice:
            return ResStrings.ShoppingSortType.highPrice
        case .lowPrice:
            return ResStrings.ShoppingSortType.lowPrice
        }
    }
    
    
}
