//
//  ConversationCell.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 09/11/21.
//

import UIKit

class ConversationCell: UICollectionViewCell {
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    override func layoutSubviews() {
        checkBox.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        checkBox.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 20).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: checkBox.rightAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        lable1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        lable1.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 15).isActive = true
        
        lable2.topAnchor.constraint(equalTo: lable1.bottomAnchor, constant: 5).isActive = true
        lable2.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 15).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let checkBox = CircularCheckBox(frame: CGRect(x: 20, y: 30, width: 20, height: 20))
    
    var imageView : UIImageView = {
        let images = UIImageView()
        images.contentMode = .left
        images.layer.cornerRadius = 40
        images.image = UIImage(systemName: "person.fill")
        images.layer.cornerRadius = 5
        images.clipsToBounds = true
//        images.backgroundColor = .darkGray
        return images
        
       
    }()
    
    var lable1: UILabel = {
        let label = UILabel()
        label.text = "abcdfadsfd"
        label.textColor = .brown
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    var lable2: UILabel = {
        let label = UILabel()
        label.text = "defsdvevfdf"
        label.textColor = .brown
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    

    
    func configure() {
        
        contentView.addSubview(lable1)
        contentView.addSubview(lable2)
        contentView.addSubview(imageView)
        contentView.addSubview(checkBox)
//        addSubview(checkBox)
//        addSubview(lable1)
//        addSubview(lable2)
//        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        lable1.translatesAutoresizingMaskIntoConstraints = false
        lable2.translatesAutoresizingMaskIntoConstraints = false
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        
        
//        NSLayoutConstraint.activate([
            
//            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
//            imageView.leftAnchor.constraint(equalTo: lable1.rightAnchor, constant: -10),
//          checkBox.rightAnchor.constraint(equalTo: stack.leftAnchor,constant: 5)
//            imageView.heightAnchor.constraint(equalToConstant: 30),
//            imageView.widthAnchor.constraint(equalToConstant: 30),
//
//
//            lable1.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
//            lable1.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 20),
//            lable1.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
//            lable1.heightAnchor.constraint(equalToConstant: 50),
//
//            lable2.topAnchor.constraint(equalTo: lable1.bottomAnchor, constant: 20),
//            lable2.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
//            lable2.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
//            lable2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
//            ])
        
//        let stack = UIStackView(arrangedSubviews: [imageView,lable1,lable2])
//        stack.axis = .vertical
//        stack.spacing = 3
//        addSubview(stack)
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
