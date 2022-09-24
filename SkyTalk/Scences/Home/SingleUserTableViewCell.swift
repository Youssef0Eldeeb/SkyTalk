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
    @IBOutlet weak var dateOfLastMsg: UILabel!
    @IBOutlet weak var unreadCounterView: UIView!
    @IBOutlet weak var unreadCounterLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        unreadCounterView.layer.cornerRadius = unreadCounterView.frame.width / 2
    }
    func configureCell(user: User){
        userName.text = user.name
        if user.imageLink != ""{
            FileStorageManager.downloadImage(imageUrl: user.imageLink) { image in
                self.userImage.image = image
            }
        }
    }
    func configure(chatRoom: ChatRoom){
        userName.text = chatRoom.receiverName
        lastMassage.text = chatRoom.lastMessage
        dateOfLastMsg.text = "\(chatRoom.date)"
        
        if chatRoom.unReadCounter != 0{
            self.unreadCounterLabel.text = "\(chatRoom.unReadCounter)"
            self.unreadCounterView.isHidden = false
        }else{
            self.unreadCounterView.isHidden = true
        }
        
        if chatRoom.avatarLink != ""{
            FileStorageManager.downloadImage(imageUrl: chatRoom.avatarLink) { image in
                self.userImage.image = image
            }
        }else{
            self.userImage.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.systemGray2)
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
