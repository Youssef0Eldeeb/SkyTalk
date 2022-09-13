//
//  LoginViewController.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 07/09/2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }    
    
    @IBAction func loginBtn(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passTextField.text!
        let userAuth = UserAuth(email: email, password: password)
        checkLoginAuthentication(userAuth)
    }
    
    
    private func checkLoginAuthentication(_ userAuth: UserAuth){
        FirebaseAuthentication().loginAuth(userAuth: userAuth) { error,isEmailVerfied  in
            if error == nil{
                if isEmailVerfied {
                    UIAlertController.showAlert(msg:"Successful Login" ,form: self)
                }else{
                    UIAlertController.showAlert(msg:"Please check your email and verify your registration" ,form: self)
                }
            }else{
                UIAlertController.showAlert(msg: error!.localizedDescription ,form: self)
            }
        }
    }
    
    
}
