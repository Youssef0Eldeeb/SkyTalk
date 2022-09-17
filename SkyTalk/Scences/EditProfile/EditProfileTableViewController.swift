//
//  EditProfileTableViewController.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 17/09/2022.
//

import UIKit

class EditProfileTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UITextField!
    
    var user: User?
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }

    @IBAction func edit(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
    }
    private func setupUI(){
        name.text = user?.name
        image.image = UIImage(data: user!.imageLink)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage{
            self.selectedImage = selectedImage
            image.image = selectedImage
        }
        dismiss(animated: true)
    }
    

}
extension EditProfileTableViewController{
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0.0 : 30.0
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            //status cell
            let controller = StatusViewController.instantiate(name: .status)
            present(controller, animated: true)
        }
    }
}
