//
//  ResColors.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/07.
//

import UIKit

enum ResColors {
    case mainBg
    case primaryLabel
    case secondaryLabel
    case placeHolder
}

extension ResColors {
    var value: UIColor {
        switch self {
        case .mainBg:
            return .systemBackground
        case .primaryLabel:
            return .label
        case .secondaryLabel:
            return .systemGray5
        case .placeHolder:
            return .lightGray
        }
    }
}
