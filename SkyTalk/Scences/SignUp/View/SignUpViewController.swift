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
    
    @IBAction func signUpBtn(_ sender: Any) {
        let email = emailTextField.text!
        let password = passTextField.text!
        signUpAuth(email: email, password: password)
    }
    
    
    func signUpAuth(email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if authResult != nil {
                let alert = UIAlertController(title: "Alert", message: "Successful sign up", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            }
            if let error = error {
                let alert = UIAlertController(title: "Alert", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                self.present(alert, animated: true)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
