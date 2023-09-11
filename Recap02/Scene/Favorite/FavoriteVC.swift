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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mainView.searchBar.resignFirstResponder()
    }
    
    override func configureView() {
        mainView.favoriteVCDelegate = self
        navigationItem.title = ResStrings.NavigationBar.favorite
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: ResColors.primaryLabel]
        
        let mainViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(mainViewTapped))
        mainView.addGestureRecognizer(mainViewTapGesture)
        let tasks = favoriteRepository.fetch(objType: FavoriteProduct.self)
        realmResultsObserve(tasks: tasks)
    }
    
    @objc private func mainViewTapped() {
        mainView.searchBar.resignFirstResponder()
    }
    
    private func realmResultsObserve(tasks: Results<FavoriteProduct>?) {
        
        guard let tasks else { return }
        
        // observe
        notificationToken = tasks.observe { [weak self] changes in
            
            guard let self else { return }
            switch changes {
            case .initial:
                self.mainView.favoriteProducts = tasks
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed.
                print("Deleted indices: ", deletions)
                print("Inserted indices: ", insertions)
                print("Modified modifications: ", modifications)
                self.mainView.favoriteProducts = tasks
                
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
}

extension FavoriteVC: FavoriteVCProtocol {
    func didSelectItemAt(item: FavoriteProduct) {
        let vc = DetailProductVC()
        vc.searchProduct = ShoppingProduct(
            productID: item.productID,
            title: item.title,
            link: item.link,
            image: item.image,
            lprice: item.lprice,
            mallName: item.mallName
        )
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func heartClicked(item: FavoriteProduct) {
        favoriteRepository.delete(item)
    }
    
    func searchBarCancelClicked(_ searchBar: UISearchBar) {
        searchBar.searchTextField.text = nil
        let tasks =  favoriteRepository.fetch(objType: FavoriteProduct.self)
        mainView.favoriteProducts = tasks
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidChange(textDidChange searchText: String) {
        // 실시간 검색 빈값일 때는 전체리스트 노출
        if searchText.isEmpty {
            let tasks = favoriteRepository.fetch(objType: FavoriteProduct.self)
            mainView.favoriteProducts = tasks
        } else {
            let tasks =  favoriteRepository.fetchFilter(objType: FavoriteProduct.self) {
                $0.titleValue.contains(searchText, options: .caseInsensitive)
            }
            mainView.favoriteProducts = tasks
        }
    }
    
    
}
