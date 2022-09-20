//
//  SingleUserTableViewCell.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 20/09/2022.
//

import UIKit

class SingleUserTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var lastMassage: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configureCell(user: User){
        userName.text = user.name
        if user.imageLink != ""{
            FileStorageManager.downloadImage(imageUrl: user.imageLink) { image in
                self.userImage.image = image
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
