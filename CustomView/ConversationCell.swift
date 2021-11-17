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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        
        addSubview(lable1)
        addSubview(lable2)
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        lable1.translatesAutoresizingMaskIntoConstraints = false
        lable2.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        NSLayoutConstraint.activate([
            
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
//            imageView.heightAnchor.constraint(equalToConstant: 30),
//            imageView.widthAnchor.constraint(equalToConstant: 30)
            

//            lable1.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
//            lable1.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
//            lable1.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
//            lable1.heightAnchor.constraint(equalToConstant: 50),
//
//            lable2.topAnchor.constraint(equalTo: lable1.bottomAnchor, constant: 20),
//            lable2.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
//            lable2.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
//            lable2.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            ])
        
        let stack = UIStackView(arrangedSubviews: [imageView,lable1,lable2])
        stack.axis = .vertical
        stack.spacing = 3
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//        stack.leadingAnchor.constraint(equalTo: imageView.leadingAnchor, constant: 5).isActive = true
    }
}
