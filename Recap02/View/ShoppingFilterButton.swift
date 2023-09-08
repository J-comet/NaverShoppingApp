//
//  ShoppingFilterButton.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/08.
//

import UIKit

class ShoppingFilterButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureView(title: String) {
        
        if #available(iOS 15.0, *) {
            
            var attString = AttributedString(title)
            attString.font = .systemFont(ofSize: 14, weight: .medium)
            attString.foregroundColor = ResColors.mainBg
            var config = UIButton.Configuration.filled()
            config.attributedTitle = attString
            config.contentInsets = .init(top: 6, leading: 4, bottom: 6, trailing: 4)
            config.baseBackgroundColor = ResColors.primaryLabel
            configuration = config
            
        } else {
            
            
            
        }
    }
}
