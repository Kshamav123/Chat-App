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
        
        selectButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        selectButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: -30).isActive = true
        selectButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        selectButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        imageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: selectButton.rightAnchor,constant: 20).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        lable1.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 23).isActive = true
        lable1.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 21).isActive = true
        
        lable2.topAnchor.constraint(equalTo: lable1.bottomAnchor, constant: 5).isActive = true
        lable2.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 21).isActive = true
        
        timelable.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        timelable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
//        timelable.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -5).isActive = true
        timelable.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 332).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var select : Bool = false
    
    var selectButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .blue
        button.addTarget(self, action: #selector(tapSelectButton), for: .touchUpInside)
        
        return button
    }()

    var imageView : UIImageView = {
        let images = UIImageView()
        images.contentMode = .scaleAspectFill
        images.image = UIImage(systemName: "person.fill")
        images.layer.cornerRadius = 23
        images.backgroundColor = UIColor(red: 0.137, green: 0.176, blue: 0.212, alpha: 1)
        images.tintColor = UIColor(red: 0.616, green: 0.647, blue: 0.675, alpha: 1)
        images.clipsToBounds = true
        return images

    }()
    
    var strokeView: UIView = {
        
        let stroke = UIView()

        stroke.layer.borderWidth = 1
        stroke.layer.borderColor = UIColor(red: 0.094, green: 0.145, blue: 0.176, alpha: 1).cgColor
        return stroke
    }()
    
//    var lable1 = CustomLabel(font: Font.font!)
//    var lable2 = CustomLabel(font: Font.font3)
//    var timelable = CustomLabel(font: Font.font3)
    
    var lable1: UILabel = {
        
        let label = UILabel()
        label.font = UIFont(name: "PTSans-Regular", size: 21)
        label.textColor = UIColor(red: 0.831, green: 0.863, blue: 0.875, alpha: 1)
        return label
    }()
    
    var lable2: UILabel = {
        
        let label = UILabel()
        label.font = UIFont(name: "PTSans-Regular", size: 17)
        label.textColor = UIColor(red: 0.576, green: 0.612, blue: 0.631, alpha: 1)
        return label
    }()
    
    var timelable: UILabel = {
        
        let label = UILabel()
//        label.font = UIFont(name: "PTSans-Regular", size: 12)
        label.font = Font.font3
        label.textColor = UIColor(red: 0.525, green: 0.561, blue: 0.58, alpha: 1)
//        label.widthAnchor.constraint(equalToConstant: 43).isActive = true
//        label.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return label
    }()
    
    @objc func tapSelectButton() {
        
        select = !select
        if select {
            selectButton.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        } else {
            selectButton.setImage(UIImage(systemName: "circle"), for: .normal)
        }        
    }
    
    func animateCell(show: Bool) {
        
        if show {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.frame.origin.x = 62
            }, completion: nil)
        } else {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.frame.origin.x = 0
            },completion: nil)
        }
    }
    
    func configure() {
        
        contentView.addSubview(lable1)
        contentView.addSubview(lable2)
        contentView.addSubview(imageView)
        contentView.addSubview(timelable)
        contentView.addSubview(selectButton)

        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        lable1.translatesAutoresizingMaskIntoConstraints = false
        lable2.translatesAutoresizingMaskIntoConstraints = false
        timelable.translatesAutoresizingMaskIntoConstraints = false
        selectButton.translatesAutoresizingMaskIntoConstraints = false

    }
}
