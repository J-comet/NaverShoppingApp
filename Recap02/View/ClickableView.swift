//
//  ClickableView.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/10.
//

import UIKit

class ClickableView: UIView {
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
        DispatchQueue.main.async {
            self.alpha = 0.5
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
                self.alpha = 1
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.async {
            self.alpha = 1
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
                self.alpha = 0.5
            }
        }
    }
    
}
