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
        loginAuth(email: email, password: password)
            
        
    }
    
    func loginAuth(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard self != nil else { return }
          
            if authResult != nil {
                let alert = UIAlertController(title: "Alert", message: "Successful Login", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self?.present(alert, animated: true)
            }
            if let error = error {
                let alert = UIAlertController(title: "Alert", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self?.present(alert, animated: true)
            }
        }
    }
    
}
