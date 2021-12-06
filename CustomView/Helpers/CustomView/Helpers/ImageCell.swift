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
    
    var message1 : Message? {
        didSet{
            
            configureImage()
        }
    }
    
    let messageImage: UIImageView = {
        let chatimage = UIImageView()
        chatimage.heightAnchor.constraint(equalToConstant: 200).isActive = true
        chatimage.widthAnchor.constraint(equalToConstant: 200).isActive = true
        chatimage.clipsToBounds = true
        chatimage.contentMode = .scaleAspectFit
        //           chatimage.translatesAutoresizingMaskIntoConstraints = false
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(view)
        view.addSubview(messageImage)
        view.addSubview(time)
        
        view.layer.cornerRadius = 5
        
        view.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        messageImage.translatesAutoresizingMaskIntoConstraints = false
        
        leftConstraint = view.leftAnchor.constraint(equalTo: leftAnchor, constant: 10)
        rightConstraint = view.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        
        NSLayoutConstraint.activate([
            
            view.widthAnchor.constraint(equalTo: messageImage.widthAnchor, constant: 20),
            view.topAnchor.constraint(equalTo: topAnchor,constant: 5),
            view.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -10),
            
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            
            leftConstraint?.isActive = false
            rightConstraint?.isActive = true
            view.backgroundColor = .link
            
        } else {
            
            leftConstraint?.isActive = true
            rightConstraint?.isActive = false
            view.backgroundColor = .magenta
            
        }
    }
}
