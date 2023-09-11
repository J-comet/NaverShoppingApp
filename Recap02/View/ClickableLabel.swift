//
//  ClickableLabel.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/11.
//

import UIKit
import SwiftUI

class ClickableLabel: UILabel {
    var onClick: () -> Void = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        onClick()
    }
}
