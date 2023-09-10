//
//  LikeProductRepository.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/10.
//

import Foundation
import RealmSwift

final class LikeProductRepository: RealmDBProtocol {
    typealias T = LikeProduct
    private let realm = try! Realm()
    private lazy var fileURL = self.realm.configuration.fileURL
    
    func printFileURL() {
        print(String(describing: fileURL))
    }
    
    func fetch(objType: LikeProduct.Type) -> Results<LikeProduct> {
        return realm.objects(objType.self)
    }
    
    func fetchFilter(objType: LikeProduct.Type, _ isIncluded: ((Query<LikeProduct>) -> Query<Bool>)) -> Results<LikeProduct> {
        return realm.objects(objType.self).where { isIncluded($0) }
    }
    
    func create(_ item: LikeProduct) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            print(#function, "ERROR")
        }
    }
    
    func update(_ item: LikeProduct) {
        do {
            try realm.write {
                realm.create(
                    LikeProduct.self,
                    value: item,
                    update: .modified
                )
            }
        } catch {
            print(#function, "error")
        }
    }
    
    func delete(_ item: LikeProduct) {
        do {
            let _ = try realm.write {
                realm.delete(item)
                print("DELETE Succeed")
            }
        } catch  {
            print(#function, "error")
        }
    }
}
