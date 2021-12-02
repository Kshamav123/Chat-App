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
    
    var message1 : Message? {
        didSet{
            var isSender: Bool
            guard let uid = DatabaseManager.shared.getUID() else{return}
            
            if uid != message1?.sender  {
                isSender = false
            } else {
                isSender = true
            }
            
            if message1?.imagePath! == "" {
                configure(isSender: isSender)
            } else {
                configureImage(isSender: isSender)
            }
            
        }
    }
    
    
    override func awakeFromNib() {
          super.awakeFromNib()
          // Initialization code
      }

      override func setSelected(_ selected: Bool, animated: Bool) {
          super.setSelected(selected, animated: animated)

          // Configure the view for the selected state
      }
 
    
    let uid = DatabaseManager.shared.getUID()
    
     var view = UIView()
    
    var message : UILabel = {
        
        let label = UILabel()

        label.textColor = .black
        label.font = Font.font2
        label.textAlignment = .left

        return label
    }()
    
    var time : UILabel = {
        
        let label = UILabel()
        label.textColor = .black
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
//           chatimage.translatesAutoresizingMaskIntoConstraints = false
           return chatimage
       }()
    
   
    
    func configure(isSender: Bool){
        
        let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "hh:mm:a"
//        message.text = message1!.message
        time.text = dateFormatter.string(from: message1!.time)
        
        view.layer.cornerRadius = 5
        message.text = message1?.message
        view.addSubview(message)
        view.addSubview(time)
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        leftConstraint = view.leftAnchor.constraint(equalTo: leftAnchor, constant: 10)
       rightConstraint = view.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        
        if isSender{
            leftConstraint?.isActive = false
            rightConstraint?.isActive = true
            view.backgroundColor = .link
    
        } else {
            
            leftConstraint?.isActive = true
            rightConstraint?.isActive = false
            view.backgroundColor = .magenta
           
        }
        NSLayoutConstraint.activate([
        
        view.widthAnchor.constraint(equalToConstant: 250),
        view.topAnchor.constraint(equalTo: topAnchor,constant: 10),
        view.bottomAnchor.constraint(equalTo:bottomAnchor,constant: -10),
        
        message.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
        message.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
        message.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
        message.rightAnchor.constraint(equalTo: time.leftAnchor, constant: -10),
        
        time.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
        time.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        time.widthAnchor.constraint(equalToConstant: 90),
        ])
    }
    
    func configureImage(isSender: Bool) {
        
        StorageManager.shared.downloadImageWithPath(path: (message1?.imagePath!)!, completion: { image in
            DispatchQueue.main.async {
                self.messageImage.image = image
            }
        })

        let dateFormatter = DateFormatter()
               dateFormatter.dateFormat = "hh:mm:a"
        time.text = dateFormatter.string(from: message1!.time)
        
        view.layer.cornerRadius = 5
        view.addSubview(messageImage)
        view.addSubview(time)
        addSubview(view)
//        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        messageImage.translatesAutoresizingMaskIntoConstraints = false
        
        leftConstraint = view.leftAnchor.constraint(equalTo: leftAnchor, constant: 10)
        rightConstraint = view.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        
        if isSender {
            leftConstraint?.isActive = false
            rightConstraint?.isActive = true
            view.backgroundColor = .link
        }else{
            leftConstraint?.isActive = true
            rightConstraint?.isActive = false
            view.backgroundColor = .magenta
        }
        
        NSLayoutConstraint.activate([
         
            view.widthAnchor.constraint(equalTo: messageImage.widthAnchor, constant: 20),
            view.topAnchor.constraint(equalTo:topAnchor,constant: 5),
            view.bottomAnchor.constraint(equalTo:bottomAnchor,constant: -10),
            
            messageImage.topAnchor.constraint(equalTo: view.topAnchor,constant: 5),
            messageImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
//            messageImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
//            messageImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
//            messageImage.rightAnchor.constraint(equalTo: time.leftAnchor, constant: -10),
            //time.centerXAnchor.constraint(equalTo: centerXAnchor),
            time.rightAnchor.constraint(equalTo:view.rightAnchor,constant: -10),
            time.topAnchor.constraint(equalTo: messageImage.bottomAnchor, constant: 10),
            time.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
            time.widthAnchor.constraint(equalToConstant: 90)
                       
                   ])
    }
}
