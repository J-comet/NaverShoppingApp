//
//  UIViewController+Extension.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/09.
//

import UIKit
import Toast


extension UIViewController {
    
    func showToast(message: String) {
        var style = ToastStyle()
        style.messageFont =  .monospacedDigitSystemFont(ofSize: 12, weight: .regular)
        style.messageColor = .white
        style.messageAlignment = .center
        style.backgroundColor = .darkGray
        self.navigationController?.view.makeToast(message, duration: 3.0, position: .bottom, style: style)
    }
}
