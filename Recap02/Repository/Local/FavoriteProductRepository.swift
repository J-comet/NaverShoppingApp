//
//  FavoriteProductRepository.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/10.
//

import Foundation
import RealmSwift

final class FavoriteProductRepository: RealmDBProtocol {
    typealias T = ShoppingProduct
    private let realm = try! Realm()
    private lazy var fileURL = self.realm.configuration.fileURL
    
    func printFileURL() {
        print(String(describing: fileURL))
    }
    
    func fetch(objType: ShoppingProduct.Type) -> Results<ShoppingProduct> {
        return realm.objects(objType.self).sorted(byKeyPath: "date", ascending: false)
    }
    
    func fetchFilter(objType: ShoppingProduct.Type, _ isIncluded: ((Query<ShoppingProduct>) -> Query<Bool>)) -> Results<ShoppingProduct> {
        return realm.objects(objType.self).where { isIncluded($0) }
    }
    
    func create(_ item: ShoppingProduct) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(#function, "ERROR")
        }
    }
    
    func update(_ item: ShoppingProduct) {
        do {
            try realm.write {
                realm.create(
                    ShoppingProduct.self,
                    value: item,
                    update: .modified
                )
            }
        } catch {
            print(#function, "error")
        }
    }
    
    func delete(_ item: ShoppingProduct) {
        do {
            let _ = try realm.write {
                realm.delete(item)
                print("DELETE Succeed")
            }
        } catch  {
            print(#function, "error")
        }
    }
    
    func favoriteProductItem(productID: String) -> ShoppingProduct? {
        return fetchFilter(objType: ShoppingProduct.self) {
            $0.productId == productID
        }.first
    }
}
