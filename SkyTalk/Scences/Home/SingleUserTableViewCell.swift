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
    func configure(chatRoom: ChatRoom){
        userName.text = chatRoom.receiverName
        lastMassage.text = chatRoom.lastMessage
        dateOfLastMsg.text = timeElapsed(chatRoom.date ?? Date())
        
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
    
    func timeElapsed(_ date: Date) -> String{
        let seconds = Date().timeIntervalSince(date)
        var elapsed = ""
        if seconds < 60 {
            elapsed = "Just now"
        }
        else if seconds < 60 * 60 {
            let minutes = Int(seconds/60)
            let minText = minutes > 1 ? "mins" : "min"
            elapsed = "\(minutes) \(minText)"
        }
        else if seconds < 24 * 60 * 60 {
            let hours = Int(seconds / (60*60))
            let hourText = hours > 1 ? "hours" : "hour"
            elapsed = "\(hours) \(hourText)"
        }
        else {
            elapsed = "\(date.longDate())"
        }
        return elapsed
    }

}
