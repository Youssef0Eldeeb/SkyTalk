//
//  FirestoreReferance.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 12/09/2022.
//

import Foundation
import FirebaseFirestore

class FirestoreManager{
    
    static let shared = FirestoreManager()
    
    func FirestorReference (_ collectionReference: FCollectionRefernce) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func saveUserToFirestore(_ user: User){
        do {
            try FirestorReference(.User).document(user.id).setData(from: user)
        } catch  {
            print(error.localizedDescription)
        }
        
    }

}



enum FCollectionRefernce: String{
    case User
}
