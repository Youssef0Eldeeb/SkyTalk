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
    
    var user: User?
    
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
            self.user = user
            name.text = user.name
            status.text = user.status
            image.image = UIImage(data: user.imageLink) 
            
            appVersion.text = "App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
        }
    }
   
}

extension ProfileTableViewController{
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 10.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            let controller = EditProfileTableViewController.instantiate(name: .editProfile)
            controller.user = user
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
