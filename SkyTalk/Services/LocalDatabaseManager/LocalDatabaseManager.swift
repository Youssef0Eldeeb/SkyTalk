//
//  LocalDatabaseManager.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 12/09/2022.
//

import Foundation

class LocalDatabaseManager{
    
    static let shared = LocalDatabaseManager()
    
    let key = "currentUser"
    let userDefault = UserDefaults.standard
    func saveUserLocally(_ user: User){
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(user){
            userDefault.set(data, forKey: key )
        }
    }
    func fetchLocalUser () -> User? {
        if let data = userDefault.data(forKey: key){
            let userObj =  decodeData(data: data)
            return userObj
        }
        return nil
    }
    private func decodeData(data: Data) -> User?{
        let decoder = JSONDecoder()
        do{
            let userObject = try decoder.decode(User.self, from: data)
            return userObject
        }catch{
            print(error.localizedDescription)
        }
        return nil
    }
    func removeLocalUser (){
        userDefault.removeObject(forKey: key)
        userDefault.synchronize()
    }
}
