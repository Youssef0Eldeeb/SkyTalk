//
//  EditProfileTableViewController.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 17/09/2022.
//

import UIKit

class EditProfileTableViewController: UITableViewController {
    

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var name: UITextField!
    
    var user: User?
    var imagePicker: UIImagePickerController!
    var selectedImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupImagePicker()
        setupTextField()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupUI()
    }

    @IBAction func edit(_ sender: UIButton) {
        present(imagePicker, animated: true)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {

        updateUserStrData()
        uploadImage(selectedImage!)
        saveImageLocally()
        navigationController?.popViewController(animated: true)
        
    }
    private func updateUserStrData(){
        if name.text != ""{
            if var user = FirebaseAuthentication.shared.currentUser {
                user.name = name.text!
                UserDefaultManager.shared.saveUserLocally(user)
                FirestoreManager.shared.saveUserToFirestore(user)
            }
        }
    }
    private func uploadImage(_ image: UIImage){
        let fileDirectory = "Image/" + "\(FirebaseAuthentication.shared.currntId)" + ".png"
        FileStorageManager.uploadImage(image, directory: fileDirectory) { imageLink in
            if var user = FirebaseAuthentication.shared.currentUser{
                user.imageLink = imageLink ?? ""
                UserDefaultManager.shared.saveUserLocally(user)
                FirestoreManager.shared.saveUserToFirestore(user)
            }
        }
    }
    private func saveImageLocally(){
        let imageData = selectedImage!.pngData()! as NSData
        let userId =  FirebaseAuthentication.shared.currntId
        FileDocumentManager.shared.saveFileLocally(fileData:imageData, fileName: userId)
    }
    
    private func setupUI(){
        name.text = user?.name
    }
    
    private func setupTextField(){
        name.delegate = self
        name.clearButtonMode = .whileEditing
    }
    
    
}


// MARK: - Extension for Image Picker

extension EditProfileTableViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    
    private func setupImagePicker(){
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage{
            self.selectedImage = selectedImage
            image.image = selectedImage
        }
        dismiss(animated: true)
    }
}
// MARK: - Extension for some properites of table view

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

// MARK: - Extension for Delegation of TextField

extension EditProfileTableViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
