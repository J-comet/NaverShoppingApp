//
//  ShoppingSearchBar.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/08.
//

import UIKit

final class ShoppingSearchBar: UISearchBar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundImage = UIImage()
        setShowsCancelButton(true, animated: false)
        if let cancelButton = value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle(ResStrings.SearchBar.cancelBtnTitle, for: .normal)
            cancelButton.setTitleColor(ResColors.placeHolder, for: .normal)
        }
        searchTextField.leftView?.tintColor = ResColors.placeHolder
        searchTextField.textColor = ResColors.primaryLabel
        searchTextField.attributedPlaceholder = NSAttributedString(string: ResStrings.SearchBar.placeHolder, attributes: [NSAttributedString.Key.foregroundColor: ResColors.placeHolder])
    }
}
