//
//  MessageCell.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 18/11/21.
//

import Foundation
import UIKit

class ChatCell: UITableViewCell {
    
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
    
    
    
     var view = UIView()
    
    var message : UILabel = {
        
        let label = UILabel()

        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textAlignment = .left
//        label.numberOfLines = 0
        return label
    }()
    
    var time : UILabel = {
        
        let label = UILabel()
//        label.text = "23"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .light)
        label.textAlignment = .center
//        label.numberOfLines = 2
        return label
    }()
    
    var sender: Bool = Bool.random()
    
    func configure(){
        
        view.layer.cornerRadius = 5
        view.backgroundColor = .link
        message.text = message1?.message
        view.addSubview(message)
        view.addSubview(time)
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            
            view.widthAnchor.constraint(equalToConstant: 250),
            view.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
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
