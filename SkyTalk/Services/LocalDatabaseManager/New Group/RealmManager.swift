//
//  RealmManager.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 29/09/2022.
//

import Foundation
import RealmSwift

class RealmManager {
    
    static let shared = RealmManager()
    let realm = try! Realm()
    
    private init () {}
    
    func save <T: Object> (_ object: T){
        do{
            try realm.write {
                realm.add(object, update: .all)
            }
        }catch{
            print(error.localizedDescription)
        }
    }
    
}
