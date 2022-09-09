//
//  InitialViewController.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 07/09/2022.
//

import UIKit

class InitialViewController: UIViewController {

    @IBOutlet weak var logoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        showLogoAnimation()
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        let controller = LoginViewController.instantiate(name: .login)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @IBAction func signUpBtn(_ sender: Any) {
        let controller  = SignUpViewController.instantiate(name: .signUp)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    func showLogoAnimation(){
        logoLabel.text = ""
        var charIndex = 0.0
        let logoText = " SkyTalk 💬 "
        for letter in logoText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * charIndex, repeats: false) { timer in
                self.logoLabel.text?.append(letter)
            }
            charIndex += 1
        }
    }
    

}
