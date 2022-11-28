//
//  RealmManager.swift
//  Telegraph
//
//  Created by Soro on 2022-11-28.
//

import Foundation
import RealmSwift

class RealmManager{
    static let shared = RealmManager()
    
    let realm = try! Realm()
    
    private init(){}
    
    func saveToRealm<T: Object>(_ object: T) {
        do {
            try realm.write({
                realm.add(object, update: .all)
            })
        } catch {
            print("Error saving realm object.", error.localizedDescription)
        }
    }
    
    func removeFromRealm<T: Object>(_ object: T) {
        do {
            try realm.write({
                realm.delete(object)
            })
        } catch {
            print("Error saving realm object.", error.localizedDescription)
        }
    }
    
    
}
