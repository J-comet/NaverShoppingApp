//
//  RealmDBProtocol.swift
//  Recap02
//
//  Created by 장혜성 on 2023/09/10.
//

import Foundation
import RealmSwift

protocol RealmDBProtocol: AnyObject {
    associatedtype T: Object
    func fetch(objType: T.Type) -> Results<T>
    func fetchFilter(objType: T.Type, _ isIncluded: ((Query<T>) -> Query<Bool>)) -> Results<T>
    func create(_ item: T)
    func update(_ item: T)
    func delete(_ item: T)
}
