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
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFieldsUI()
        
    }
    
    @IBAction func choosePhoto(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func resendVerficationEmailBtn(_ sender: UIButton) {
        resendVerificationEmail()
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
                UIAlertController.showAlert(msg: "Successful sign up", form: self)
            }
        }
    }
    
    private func resendVerificationEmail(){
        FirebaseAuthentication.shared.resendVerificationEmail(email: emailTextField.text!) { error in
            if error == nil{
                UIAlertController.showAlert(msg: "Verification email sent successfully", form: self)
            }else{
                UIAlertController.showAlert(msg: error!.localizedDescription, form: self)
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
}
// MARK: - Extension for Image Picker

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
 
    private func setupImagePicker(){
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage{
            self.selectedImage = selectedImage
            profileImageView.image = selectedImage
        }
        dismiss(animated: true)
    }
}
