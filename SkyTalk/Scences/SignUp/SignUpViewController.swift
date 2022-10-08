//
//  SignUpViewController.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 07/09/2022.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTitle: UILabel!
    @IBOutlet weak var lastNameTitle: UILabel!
    @IBOutlet weak var emailTitle: UILabel!
    @IBOutlet weak var passwordTitle: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        setupTextFieldsUI()
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passTextField.text ?? ""
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let name = firstName + " " + lastName
        let userAuth = UserAuth(email: email, password: password, name: name)
        checkSignupAuthentication(userAuth)
    }
    
    private func checkSignupAuthentication(_ userAuth: UserAuth){
        FirebaseAuthentication.shared.signUpAuth(userAuth: userAuth) { error in
            if let error = error {
                UIAlertController.showAlert(msg: error.localizedDescription, form: self)
            }
            if error == nil {
                let controller = VerifySignUPViewController.instantiate(name: .signUp)
                controller.comingUserAuth = userAuth
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }

    
    private func setupTextFieldsUI(){
        firstNameTitle.text = ""
        lastNameTitle.text = ""
        emailTitle.text = ""
        passwordTitle.text = ""
        
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        passTextField.delegate = self
    }
    
    
   
}
// MARK: - Extension for Delegation of TextField

extension SignUpViewController: UITextFieldDelegate{
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        firstNameTitle.text = firstNameTextField.hasText ? "First Name" : ""
        lastNameTitle.text = lastNameTextField.hasText ? "Last Name" : ""
        emailTitle.text = emailTextField.hasText ? "Email" : ""
        passwordTitle.text = passTextField.hasText ? "Password" : ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text != "" {
            let email = emailTextField.text ?? ""
            let password = passTextField.text ?? ""
            let firstName = firstNameTextField.text ?? ""
            let lastName = lastNameTextField.text ?? ""
            let name = firstName + " " + lastName
            let userAuth = UserAuth(email: email, password: password, name: name)
            checkSignupAuthentication(userAuth)
            return true
        }else{
            textField.resignFirstResponder()
            return true
        }
    }
}
