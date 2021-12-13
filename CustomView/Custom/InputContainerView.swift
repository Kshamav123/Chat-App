//
//  InputContainerView.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 11/11/21.
//

import Foundation
import UIKit

class InputContainerView: UIView {
    
    init(image: UIImage,textField: UITextField, backgroundColor: UIColor?) {
        super.init(frame: .zero)
        
        heightAnchor.constraint(equalToConstant: 50).isActive = true
//        backgroundColor = .white
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 10
        layer.borderColor = UIColor(red: 0.176, green: 0.22, blue: 0.243, alpha: 1).cgColor
        layer.borderWidth = 2
        
        let iv = UIImageView()
        addSubview(iv)
        iv.image = image
        iv.tintColor = UIColor(red: 0.655, green: 0.675, blue: 0.69, alpha: 1)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        iv.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 24).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: iv.rightAnchor, constant: 10).isActive = true
//        textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 5).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
