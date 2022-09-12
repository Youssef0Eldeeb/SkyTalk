//
//  FirebaseAuthentication.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 10/09/2022.
//

import Foundation
import FirebaseAuth

class FirebaseAuthentication{
    
    //Login Authentication
    func loginAuth(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool)->(Void)){
        
        Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
            if error == nil && authResult!.user.isEmailVerified{
                completion(error,true)
                self.downloadUserFormFirestore(userId: authResult!.user.uid)
            }else {
                completion(error,false)
            }
        }
    }
    
    private func downloadUserFormFirestore(userId: String){
        FirestoreManager().FirestorReference(.User).document(userId).getDocument { document, error in
            guard let userDecoument = document else{
                print("No Data Found")
                return
            }
            let result = Result{
                try? userDecoument.data (as: User.self)
            }
            switch result {
            case .success(let userObj):
                if let user = userObj {
                    self.saveUserLocally(user)
                }else{
                    print("No Document Found")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //Sign Up Authentication
    func signUpAuth(email: String, password: String, completion: @escaping (_ error: Error?)->Void){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            completion(error)
            if error == nil {
                authResult!.user.sendEmailVerification{ error in
                    completion(error)
                }
            }
            if authResult?.user != nil {
                let user = User(id: authResult!.user.uid, pushId: "", imageLink: "", name: "", email: email, status: "")
                self.saveUserToFirestore(user)
                self.saveUserLocally(user)
            }
            
        }
    }
    
    private func saveUserToFirestore(_ user: User){
        do {
            try FirestoreManager().FirestorReference(.User).document(user.id).setData(from: user)
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    private func saveUserLocally(_ user: User){
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(user){
            UserDefaults.standard.set(data, forKey: "currentUser")
        }
    }
    
}
