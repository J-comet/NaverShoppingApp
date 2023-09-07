//
//  FavoriteVC.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/07.
//

import UIKit
import BaseKit

final class FavoriteVC: BaseViewController<FavoriteView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ResStrings.NavigationBar.favorite
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ResColors.primaryLabel.value]
    }
    
    override func configureView() {
        
    }
    
}
