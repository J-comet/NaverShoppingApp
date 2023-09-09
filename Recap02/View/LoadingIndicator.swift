//
//  LoadingIndicator.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/09.
//

import UIKit

class LoadingIndicator {
    
    static func show() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            
            let indicatorView: UIActivityIndicatorView
            if let existedView = window.subviews.first(where: { $0 is UIActivityIndicatorView } ) as? UIActivityIndicatorView {
                indicatorView = existedView
            } else {
                indicatorView = UIActivityIndicatorView(style: .medium)
                indicatorView.frame = window.frame
                indicatorView.color = ResColors.loading
                window.addSubview(indicatorView)
            }
            
            indicatorView.startAnimating()
        }
    }
    
    static func hide() {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.windows.last else { return }
            window.subviews.filter({ $0 is UIActivityIndicatorView }).forEach { $0.removeFromSuperview() }
        }
    }
}
