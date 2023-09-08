//
//  SearchVC.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/07.
//

import UIKit
import BaseKit

protocol SearchVCProtocol: AnyObject {
    func searchBarCancelClicked(_ searchBar: UISearchBar)
    func searchBarSearchClicked(_ searchBar: UISearchBar)
}

final class SearchVC: BaseViewController<SearchView> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        navigationItem.title = ResStrings.NavigationBar.search
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ResColors.primaryLabel]
    }
    
    override func configureView() {
        
    }
    
}

extension SearchVC: SearchVCProtocol {
    func searchBarCancelClicked(_ searchBar: UISearchBar) {
        print(#function, "취소 버튼")
    }
    
    func searchBarSearchClicked(_ searchBar: UISearchBar) {
        print(#function, "검색 버튼")
    }
}

