//
//  FavoriteProductRepository.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/10.
//

import Foundation
import RealmSwift

final class FavoriteProductRepository: RealmDBProtocol {
    typealias T = FavoriteProduct
    private let realm = try! Realm()
    private lazy var fileURL = self.realm.configuration.fileURL
    
    func printFileURL() {
        print(String(describing: fileURL))
    }
    
    func fetch(objType: FavoriteProduct.Type) -> Results<FavoriteProduct> {
        return realm.objects(objType.self).sorted(byKeyPath: "date", ascending: false)
    }
    
    func fetchFilter(objType: FavoriteProduct.Type, _ isIncluded: ((Query<FavoriteProduct>) -> Query<Bool>)) -> Results<FavoriteProduct> {
        return realm.objects(objType.self).where { isIncluded($0) }
    }
    
    func create(_ item: FavoriteProduct) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(#function, "ERROR")
        }
    }
    
    func update(_ item: FavoriteProduct) {
        do {
            try realm.write {
                realm.create(
                    FavoriteProduct.self,
                    value: item,
                    update: .modified
                )
            }
        } catch {
            print(#function, "error")
        }
    }
    
    func delete(_ item: FavoriteProduct) {
        do {
            let _ = try realm.write {
                realm.delete(item)
                print("DELETE Succeed")
            }
        } catch  {
            print(#function, "error")
        }
    }
    
    func favoriteProductItem(productID: String) -> FavoriteProduct? {
        return fetchFilter(objType: FavoriteProduct.self) {
            $0.productID == productID
        }.first
    }
}
