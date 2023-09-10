//
//  FavoriteVC.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/07.
//

import UIKit
import BaseKit
import RealmSwift

final class FavoriteVC: BaseViewController<FavoriteView> {
    
    private let favoriteRepository = FavoriteProductRepository()
    
    private var notificationToken: NotificationToken?
    
    deinit {
        // realm 노티피케이션 제거
        notificationToken?.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = ResStrings.NavigationBar.favorite
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ResColors.primaryLabel]
        
        let tasks = favoriteRepository.fetch(objType: FavoriteProduct.self)
        realmResultsObserve(tasks: tasks)
    }
    
    override func configureView() {
        mainView.favoriteVCDelegate = self
    }
    
    private func realmResultsObserve(tasks: Results<FavoriteProduct>?) {
        
        guard let tasks else { return }
        
        // observe
        notificationToken = tasks.observe { [weak self] changes in
            
            guard let self else { return }
            switch changes {
            case .initial:
                self.mainView.favoriteProducts.append(contentsOf: tasks)
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed.
                print("Deleted indices: ", deletions)
                print("Inserted indices: ", insertions)
                print("Modified modifications: ", modifications)
                self.mainView.favoriteProducts.removeAll()
                self.mainView.favoriteProducts.append(contentsOf: tasks)
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
}

extension FavoriteVC: FavoriteVCProtocol {
    func didSelectItemAt(item: FavoriteProduct) {
        
    }
    
    func heartClicked(item: FavoriteProduct) {
        
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
