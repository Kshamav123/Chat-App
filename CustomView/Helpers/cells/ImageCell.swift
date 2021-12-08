//
//  ImageCell.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 03/12/21.
//

import Foundation
import UIKit

class ImageCell: UITableViewCell {
    
    var isSender: Bool!
    
    var leftConstraint : NSLayoutConstraint!
    var rightConstraint : NSLayoutConstraint!
    var currentSenderTopConstraint : NSLayoutConstraint?
    var receiverMessageTopConstraint : NSLayoutConstraint?
    var senderNameTopConstraint : NSLayoutConstraint?
    
    var message1 : Message? {
        didSet{
            
            configureImage()
        }
    }
    
    var userList: [UserData]? {
        
        didSet{
            configureSender()
        }
    }
    
    let messageImage: UIImageView = {
        let chatimage = UIImageView()
        chatimage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        chatimage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        chatimage.clipsToBounds = true
        chatimage.contentMode = .scaleAspectFit
      
        return chatimage
    }()
    var time : UILabel = {
        
        let label = UILabel()
        label.textColor = .black
        label.font = Font.font3
        label.textAlignment = .center
        
        return label
    }()
    
    var view = UIView()
    var sendersName: UILabel = {
  
        let label = UILabel()
        
        label.textColor = .blue
        label.font = Font.font
        label.textAlignment = .left
        label.text = ""
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(view)
        view.addSubview(messageImage)
        view.addSubview(time)
        view.addSubview(sendersName)
        
        view.layer.cornerRadius = 5
        
        view.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        messageImage.translatesAutoresizingMaskIntoConstraints = false
        sendersName.translatesAutoresizingMaskIntoConstraints = false
        
        leftConstraint = view.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
        rightConstraint = view.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        currentSenderTopConstraint = messageImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 10)
        receiverMessageTopConstraint = messageImage.topAnchor.constraint(equalTo: sendersName.bottomAnchor, constant: 5)
        senderNameTopConstraint = sendersName.topAnchor.constraint(equalTo: view.topAnchor, constant: 10)
        
        NSLayoutConstraint.activate([
            
            view.widthAnchor.constraint(equalTo: messageImage.widthAnchor, constant: 20),
            view.topAnchor.constraint(equalTo: topAnchor,constant: 5),
            view.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -5),
 
            sendersName.widthAnchor.constraint(equalToConstant: 80),
            messageImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),

            time.rightAnchor.constraint(equalTo:view.rightAnchor,constant: -10),
            time.topAnchor.constraint(equalTo: messageImage.bottomAnchor, constant: 5),
            time.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),

            sendersName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            
            // Configure the view for the selected state
        }
    
    func configureImage() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        //        message.text = message1!.message
        time.text = dateFormatter.string(from: message1!.time)
        
        StorageManager.shared.downloadImageWithPath(path: (message1?.imagePath!)!, completion: { image in
            DispatchQueue.main.async {
                self.messageImage.image = image
            }
        })
        
        if message1?.sender == DatabaseManager.shared.getUID() {
            
            sendersName.isHidden = true
            receiverMessageTopConstraint?.isActive = false
            senderNameTopConstraint?.isActive = false
            currentSenderTopConstraint?.isActive = true
            leftConstraint?.isActive = false
            rightConstraint?.isActive = true
            view.backgroundColor = .link
            
        } else {
        
            sendersName.isHidden = false
            currentSenderTopConstraint?.isActive = false
            receiverMessageTopConstraint?.isActive = true
            senderNameTopConstraint?.isActive = true
            leftConstraint?.isActive = true
            rightConstraint?.isActive = false
            view.backgroundColor = .magenta
            
        }
    }
    
    func configureSender() {
        
        for user in userList! {
            if message1?.sender == user.uid {             
                sendersName.text = user.username
              
            }
        }
    }
}
