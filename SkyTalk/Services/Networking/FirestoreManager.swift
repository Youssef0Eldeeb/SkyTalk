//
//  FirestoreReferance.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 12/09/2022.
//

import Foundation
import FirebaseFirestore

class FirestoreManager{
    
    func FirestorReference (_ collectionReference: FCollectionRefernce) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }

}



enum FCollectionRefernce: String{
    case User
}
