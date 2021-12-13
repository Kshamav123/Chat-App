//
//  MessageCell.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 18/11/21.
//

import Foundation
import UIKit

class ChatCell: UITableViewCell {
    
    var leftConstraint : NSLayoutConstraint?
    var rightConstraint : NSLayoutConstraint?
    var currentSenderTopConstraint : NSLayoutConstraint?
    var receiverMessageTopConstraint : NSLayoutConstraint?
    var senderNameTopConstraint : NSLayoutConstraint?
    
    var message1 : Message? {
        didSet{
       configure()
    }
}
    var userList: [UserData]? {
        
        didSet{
            configureSender()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
        
             
        
        addSubview(view)
        view.addSubview(time)
        view.addSubview(message)
        view.addSubview(sendersName)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        sendersName.translatesAutoresizingMaskIntoConstraints = false
        
        view.layer.cornerRadius = 5
        
        leftConstraint = view.leftAnchor.constraint(equalTo: leftAnchor, constant: 32)
        rightConstraint = view.rightAnchor.constraint(equalTo: rightAnchor, constant: -32)
        currentSenderTopConstraint = message.topAnchor.constraint(equalTo: view.topAnchor, constant: 10)
        receiverMessageTopConstraint = message.topAnchor.constraint(equalTo: sendersName.bottomAnchor, constant: 5)
        senderNameTopConstraint = sendersName.topAnchor.constraint(equalTo: view.topAnchor, constant: 10)
               
        NSLayoutConstraint.activate([
            
            message.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            view.widthAnchor.constraint(equalTo: message.widthAnchor, constant: 80),
            view.topAnchor.constraint(equalTo: topAnchor,constant: 5),
            view.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -5),
            
            sendersName.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            sendersName.widthAnchor.constraint(equalToConstant: 80),

            message.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            
            time.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            time.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 5),
            time.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),

        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    
    var view = UIView()
    
    var message : UILabel = {
        
        let label = UILabel()
        
        label.textColor = UIColor(red: 0.765, green: 0.867, blue: 0.863, alpha: 1)
        label.font = UIFont(name: "PTSans-Regular", size: 16)
        label.textAlignment = .left
        label.numberOfLines = 0
        
        return label
    }()
    
    var time : UILabel = {
        
        let label = UILabel()
        label.textColor = UIColor(red: 0.502, green: 0.702, blue: 0.682, alpha: 1)
        label.font = Font.font3
        label.textAlignment = .center
        
        return label
    }()
    
    let messageImage: UIImageView = {
        let chatimage = UIImageView()
        chatimage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        chatimage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        chatimage.clipsToBounds = true
        chatimage.contentMode = .scaleAspectFit
       
        return chatimage
    }()
    
    var sendersName: UILabel = {
  
        let label = UILabel()
        
        label.textColor = .orange
        label.font = Font.font
        label.textAlignment = .left
        label.text = " "
        return label
    }()
    
    func configure(){
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        //        message.text = message1!.message
        time.text = dateFormatter.string(from: message1!.time)
        
        message.text = message1?.message
        
        
        if message1?.sender == DatabaseManager.shared.getUID() {
            
            sendersName.isHidden = true
            receiverMessageTopConstraint?.isActive = false
            senderNameTopConstraint?.isActive = false
            currentSenderTopConstraint?.isActive = true
            leftConstraint?.isActive = false
            rightConstraint?.isActive = true
            view.backgroundColor = UIColor(red: 0.02, green: 0.275, blue: 0.251, alpha: 1)
            

            
        } else {
            
            sendersName.isHidden = false
            currentSenderTopConstraint?.isActive = false
            receiverMessageTopConstraint?.isActive = true
            senderNameTopConstraint?.isActive = true
            leftConstraint?.isActive = true
            rightConstraint?.isActive = false
            view.backgroundColor = UIColor(red: 0.137, green: 0.176, blue: 0.212, alpha: 1)
            
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
