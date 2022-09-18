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
    var navigatImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadAndShowUserInfo()
    }

    @IBAction func logOut(_ sender: UIButton) {
        FirebaseAuthentication.shared.logoutCurrentUser { error in
            if error == nil{
                self.goBackToHome()
            }else{
                UIAlertController.showAlert(msg: error!.localizedDescription, form: self)
            }
        }
    }
    private func goBackToHome(){
        let controller = InitialViewController.instantiate(name: .initial)
        controller.modalPresentationStyle = .fullScreen
        controller.modalTransitionStyle = .crossDissolve
        self.present(controller, animated: true, completion: nil)
    }
    
    
    
    private func loadAndShowUserInfo(){
        if let user = FirebaseAuthentication.shared.currentUser {
            self.user = user
            name.text = user.name
            status.text = user.status
            
            appVersion.text = "App Version \(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")"
            if user.imageLink != ""{
                FileStorageManager.downloadImage(imageUrl: user.imageLink) { image in
                    self.image.image = image
                    self.navigatImage = image
                }
            }
        }
    }
   
}
// MARK: - Extension for some properites of table view

extension ProfileTableViewController{
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 10.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 0 {
            let controller = EditProfileTableViewController.instantiate(name: .editProfile)
            controller.user = user
            controller.comingImage = navigatImage
            navigationController?.pushViewController(controller, animated: true)
        }
    }
}
