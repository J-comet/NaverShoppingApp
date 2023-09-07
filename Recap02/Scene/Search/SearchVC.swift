//
//  SearchVC.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/07.
//

import UIKit
import BaseKit

final class SearchVC: BaseViewController<SearchView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ResStrings.NavigationBar.search
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ResColors.primaryLabel]
    }
    
    override func configureView() {
//        mainView.searchBar.delegate = self
    }
    
}

//extension SearchVC: UISearchBarDelegate {
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//         let cBtn = searchBar.value(forKey: "cancelButton") as! UIButton
//         cBtn.setTitle("Cancel", for: .normal)
//    }
//}
