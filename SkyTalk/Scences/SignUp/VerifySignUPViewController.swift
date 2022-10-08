//
//  VerifySignUPViewController.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 08/10/2022.
//

import UIKit

class VerifySignUPViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var comingUserAuth: UserAuth?
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        // Do any additional setup after loading the view.
    }
    @IBAction func GoToApp(_ sender: UIButton) {
        if comingUserAuth != nil {
            checkLoginAuthentication(comingUserAuth!)
        }
        
    }
    
    @IBAction func resendVerficationEmailBtn(_ sender: UIButton) {
        resendVerificationEmail()
    }

    private func checkLoginAuthentication(_ userAuth: UserAuth){
        FirebaseAuthentication.shared.loginAuth(userAuth: userAuth) { error,isEmailVerfied  in
            if error == nil{
                if isEmailVerfied {
                    self.goToApp()
                    self.activityIndicator.stopAnimating()
                }else{
                    UIAlertController.showAlert(msg:"Please check your email and verify your registration" ,form: self)
                }
            }else{
                UIAlertController.showAlert(msg: error!.localizedDescription ,form: self)
            }
        }
    }
    private func goToApp(){
        let controller = UITabBarController.instantiate(name: .home)
        
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .flipHorizontal
        self.present(controller, animated: true)
    }
    
    private func resendVerificationEmail(){
        FirebaseAuthentication.shared.resendVerificationEmail(email: comingUserAuth!.email) { error in
            if error == nil{
                UIAlertController.showAlert(msg: "Verification email sent successfully", form: self)
            }else{
                UIAlertController.showAlert(msg: error!.localizedDescription, form: self)
            }
        }
    }

}
