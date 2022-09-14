//
//  SignUpViewController.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 07/09/2022.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func resendVerficationEmailBtn(_ sender: UIButton) {
        resendVerificationEmail()
    }
    @IBAction func signUpBtn(_ sender: Any) {
        let email = emailTextField.text ?? ""
        let password = passTextField.text ?? ""
        let userAuth = UserAuth(email: email, password: password)
        checkSignupAuthentication(userAuth)
    }
    
    
    
    private func checkSignupAuthentication(_ userAuth: UserAuth){
        FirebaseAuthentication().signUpAuth(userAuth: userAuth) { error in
            if let error = error {
                UIAlertController.showAlert(msg: error.localizedDescription, form: self)
            }
            if error == nil {
                UIAlertController.showAlert(msg: "Successful sign up", form: self)
            }
        }
    }
    private func resendVerificationEmail(){
        FirebaseAuthentication().resendVerificationEmail(email: emailTextField.text!) { error in
            if error == nil{
                UIAlertController.showAlert(msg: "Verification email sent successfully", form: self)
            }else{
                UIAlertController.showAlert(msg: error!.localizedDescription, form: self)
            }
        }
    }
    
   
}
