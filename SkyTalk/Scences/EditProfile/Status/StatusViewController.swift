//
//  StatusViewController.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 17/09/2022.
//

import UIKit

class StatusViewController: UIViewController {

    
    @IBOutlet weak var status: UITextField!
    
    @IBOutlet weak var done: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        status.delegate = self
        done.tintColor = .systemGray2
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        if done.tintColor == .systemBlue{
            dismiss(animated: true)
        }
    }
    

}

extension StatusViewController: UITextFieldDelegate{
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if status.text == ""{
            done.tintColor = .systemGray2
        }else{
            done.tintColor = .systemBlue
        }
    }
}
