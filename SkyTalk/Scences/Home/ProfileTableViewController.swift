//
//  ProfileTableViewController.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 14/09/2022.
//

import UIKit

class ProfileTableViewController: UITableViewController {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var appVersion: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        showUserInfo()
    }
    
    @IBAction func logOut(_ sender: UIButton) {
        FirebaseAuthentication.shared.logoutCurrentUser { error in
            if error == nil{
                let controller = InitialViewController.instantiate(name: .initial)
                controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .crossDissolve
                self.present(controller, animated: true, completion: nil)
                
            }else{
                UIAlertController.showAlert(msg: error!.localizedDescription, form: self)
            }
        }
    }
    
    
    
    private func showUserInfo(){
        if let user = FirebaseAuthentication.shared.currentUser {
            name.text = user.name
            status.text = user.status
            
            appVersion.text = "App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
        }
    }
   
}
