//
//  FavoriteVCProtocol.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/10.
//

import UIKit

protocol FavoriteVCProtocol: AnyObject {
    func searchBarCancelClicked(_ searchBar: UISearchBar)
    func searchBarSearchClicked(_ searchBar: UISearchBar)
    func searchBarTextDidChange(textDidChange searchText: String)
    func didSelectItemAt(item: FavoriteProduct)
    func heartClicked(item: FavoriteProduct)
    func emptyMoveLabelClicked()
}
