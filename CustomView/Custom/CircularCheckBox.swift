//
//  CircularCheckBox.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 18/11/21.
//

import Foundation

import UIKit

class CircularCheckBox: UIView {
    
    var checked :Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderWidth = 1
        layer.borderColor = UIColor.secondaryLabel.cgColor
        layer.cornerRadius = frame.size.width / 2
        backgroundColor = .systemBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checking() {
        checked = !checked
       if checked {
            backgroundColor = .black
        }
        else {
            backgroundColor = .systemBackground
        }
    }
}
