//
//  SearchVCProtocol.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/09.
//

import UIKit

protocol SearchVCProtocol: AnyObject {
    func searchBarCancelClicked(_ searchBar: UISearchBar)
    func searchBarSearchClicked(_ searchBar: UISearchBar)
    func filterClicked(selectedFilterButton: UIButton)
}
