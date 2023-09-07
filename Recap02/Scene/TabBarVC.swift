//
//  TabBarVC.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/07.
//

import UIKit

final class TabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 0
        let viewControllers = [tapVC(type: .search), tapVC(type: .favorite)]
        setViewControllers(viewControllers, animated: true)
        
        tabBar.backgroundColor = ResColors.mainBg
        tabBar.tintColor = ResColors.primaryLabel
        tabBar.unselectedItemTintColor = ResColors.secondaryLabel
    }
    
    private func tapVC(type: TabType) -> UINavigationController {
        let nav = UINavigationController()
        nav.addChild(type.vc)
        nav.tabBarItem.image = type.defaultIcon
        nav.tabBarItem.selectedImage = type.selectedIcon
        nav.tabBarItem.title = type.title
        return nav
    }
}

extension TabBarVC {
    
    enum TabType {
    case search
    case favorite
        
        var vc: UIViewController {
            switch self {
            case .search:
                return SearchVC()
            case .favorite:
                return FavoriteVC()
            }
        }
    
        var title: String {
            switch self {
            case .search:
                return ResStrings.TabBar.search
            case .favorite:
                return ResStrings.TabBar.favorite
            }
        }
        
        var defaultIcon: UIImage {
            switch self {
            case .search:
                return UIImage(systemName: "magnifyingglass")!
            case .favorite:
                return UIImage(systemName: "heart")!
            }
        }
        
        var selectedIcon: UIImage {
            switch self {
            case .search:
                return UIImage(systemName: "magnifyingglass")!
            case .favorite:
                return UIImage(systemName: "heart.fill")!
            }
        }
        
    }
}
