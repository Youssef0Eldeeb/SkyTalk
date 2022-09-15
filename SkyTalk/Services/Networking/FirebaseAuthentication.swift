//
//  FirebaseAuthentication.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 10/09/2022.
//

import Foundation
import FirebaseAuth

class FirebaseAuthentication{
    
    static let shared = FirebaseAuthentication()
    
    var currentUser: User? {
        if Auth.auth().currentUser != nil{
            let fetchedData = LocalDatabaseManager.shared.fetchLocalUser()
            return fetchedData
        }else{
            return nil
        }
    }
    
    func loginAuth(userAuth: UserAuth, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool)->(Void)){
        Auth.auth().signIn(withEmail: userAuth.email, password: userAuth.password) {authResult, error in
            if error == nil && authResult!.user.isEmailVerified{
                completion(error,true)
                self.downloadUserFormFirestore(userId: authResult!.user.uid)
            }else {
                completion(error,false)
            }
        }
    }
    
    private func downloadUserFormFirestore(userId: String){
        FirestoreManager.shared.FirestorReference(.User).document(userId).getDocument { document, error in
            guard let userDecoument = document else{return}
            let result = Result{
                try? userDecoument.data (as: User.self)
            }
            switch result {
            case .success(let userObj):
                if let user = userObj {
                    LocalDatabaseManager.shared.saveUserLocally(user)
                }else{
                    print("No Document Found")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    //Sign Up Authentication
    func signUpAuth(userAuth: UserAuth, completion: @escaping (_ error: Error?)->Void){
        Auth.auth().createUser(withEmail: userAuth.email, password: userAuth.password) { authResult, error in
            completion(error)
            if error == nil {
                authResult!.user.sendEmailVerification{ error in
                    completion(error)
                }
            }
            if authResult?.user != nil {
                let user = User(id: authResult!.user.uid, pushId: "", imageLink: "", name: userAuth.name ?? "", email: userAuth.email, status: "")
                self.saveUserToFirestore(user)
                LocalDatabaseManager.shared.saveUserLocally(user)
            }
            
        }
    }
    
    private func saveUserToFirestore(_ user: User){
        do {
            try FirestoreManager.shared.FirestorReference(.User).document(user.id).setData(from: user)
        } catch  {
            print(error.localizedDescription)
        }
        
    }
    
    func resendVerificationEmail(email:String, completion: @escaping(_ error: Error?) -> Void){
        Auth.auth().currentUser?.reload(completion: { error in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion(error)
            })
        })
    }
    func resetPassword(email: String, completion: @escaping(_ error: Error?) -> Void){
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    func logoutCurrentUser(completion: @escaping (_ error: Error?) -> (Void)){
        do{
            try Auth.auth().signOut()
            LocalDatabaseManager.shared.removeLocalUser()
            completion(nil)
        }catch let error as NSError{
            completion(error)
        }
    }
    
}
