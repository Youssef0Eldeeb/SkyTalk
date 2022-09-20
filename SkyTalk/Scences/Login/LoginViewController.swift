//
//  LoginViewController.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 07/09/2022.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var passwordTitle: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }    
    @IBAction func forgetPasswordBtn(_ sender: UIButton) {
        forgetPassword()
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        let email = emailTextField.text!
        let password = passTextField.text!
        let userAuth = UserAuth(email: email, password: password)
        checkLoginAuthentication(userAuth)
    }
    
    
    private func checkLoginAuthentication(_ userAuth: UserAuth){
        FirebaseAuthentication.shared.loginAuth(userAuth: userAuth) { error,isEmailVerfied  in
            if error == nil{
                if isEmailVerfied {
                    self.goToApp()
                }else{
                    UIAlertController.showAlert(msg:"Please check your email and verify your registration" ,form: self)
                }
            }else{
                UIAlertController.showAlert(msg: error!.localizedDescription ,form: self)
            }
        }
    }
    
    private func forgetPassword(){
        FirebaseAuthentication.shared.resetPassword(email: emailTextField.text!) { error in
            if error == nil{
                UIAlertController.showAlert(msg: "Reset password email has been sent", form: self)
            }else{
                UIAlertController.showAlert(msg: error!.localizedDescription, form: self)
            }
        }
    }
    
    private func goToApp(){
        let controller = UITabBarController.instantiate(name: .home)
        
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        self.present(controller, animated: true)
    }
    
    private func setupUI(){
        emailTitle.text = ""
        passwordTitle.text = ""
        
        emailTextField.delegate = self
        passTextField.delegate = self
    }
    
    
}

// MARK: - Extension for Delegation of TextField

extension LoginViewController: UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        emailTitle.text = emailTextField.hasText ? "Email" : ""
        passwordTitle.text = passTextField.hasText ? "Password" : ""
    }
}
