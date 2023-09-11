//
//  ResStrings.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/07.
//

import Foundation
import BaseKit

struct ResStrings {
    
    struct TabBar {
        static let search = "tabSearch".localized
        static let favorite = "tabFavorite".localized
    }
    
    struct NavigationBar {
        static let search = "navSearch".localized
        static let favorite = "navFavorite".localized
    }
    
    struct SearchBar {
        static let placeHolder = "searchbarPlaceHolder".localized
        static let cancelBtnTitle = "searchbarBtnCancel".localized
    }
    
    struct ShoppingSortType {
        static let accuracy = "sortAccuracy".localized
        static let date = "sortDate".localized
        static let highPrice = "sortHighPrice".localized
        static let lowPrice = "sortLowPrice".localized
    }
    
    struct Guide {
        static let searchDefaultGuide = "searchDefaultGuide".localized
        static let searchResultEmpty = "searchResultEmpty".localized
        static let searchInputTextEmpty = "searchInputTextEmpty".localized
        static let searchFail = "searchFail".localized
        
        static let favoriteDefaultGuide = "favoriteDefaultGuide".localized
        static let moveFavoriteToSearch = "moveFavoriteToSearch".localized
        static let notFoundWebViewURL = "notFoundWebViewURL".localized
        
        static let webViewReload = "webViewReload".localized
    }
    
    struct Network {
        static let networkError = "networkError".localized
    }
}
