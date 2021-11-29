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
            configure()
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
    
    var sender: Bool = Bool.random()
    
    func configure(){
        
        view.layer.cornerRadius = 5
//        view.backgroundColor = .link
        message.text = message1?.message
        view.addSubview(message)
        view.addSubview(time)
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        leftConstraint = view.leftAnchor.constraint(equalTo: leftAnchor, constant: 10)
       rightConstraint = view.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
        
        if message1?.sender == uid {
//            view.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
            leftConstraint?.isActive = false
            rightConstraint?.isActive = true
            view.backgroundColor = .link
        
            
        } else {
            
            leftConstraint?.isActive = true
            rightConstraint?.isActive = false
            view.backgroundColor = .magenta
//            view.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
           
        }
        NSLayoutConstraint.activate([
        
        view.widthAnchor.constraint(equalToConstant: 250),
//        view.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
        view.topAnchor.constraint(equalTo: message.topAnchor,constant: 10),
        view.bottomAnchor.constraint(equalTo: message.bottomAnchor,constant: 10),
        
        message.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
        message.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
//            message.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        message.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10),
        message.rightAnchor.constraint(equalTo: time.leftAnchor, constant: -10),
        
        time.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
        time.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            time.bottomAnchor.constraint(equalTo: message.bottomAnchor),
        time.widthAnchor.constraint(equalToConstant: 30),
        ])
    }
}
