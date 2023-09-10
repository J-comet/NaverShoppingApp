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
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ResColors.primaryLabel]
    }
    
    override func configureView() {
        mainView.favoriteVCDelegate = self
    }
    
}

extension FavoriteVC: FavoriteVCProtocol {
    func didSelectItemAt(item: LikeProduct) {
        
    }
    
    func heartClicked(item: LikeProduct) {
        
    }
    
    func prefetchItemsAt(prefetchItemsAt indexPaths: [IndexPath]) {
        
    }
    
    func searchBarCancelClicked(_ searchBar: UISearchBar) {
        print(#function, "취소")
    }
    
    func searchBarSearchClicked(_ searchBar: UISearchBar) {
        print(#function, "검색")
    }
    
    func searchBarTextDidChange(textDidChange searchText: String) {
        print(#function, "실시간 검색")
    }
    
    
}
