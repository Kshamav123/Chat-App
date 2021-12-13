//
//  CustomButton.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 17/11/21.
//

import Foundation
import UIKit

class CustomButton: UIButton {
    
    init(setTitle: String) {
        super.init(frame: .zero)
        backgroundColor = UIColor(red: 0.02, green: 0.275, blue: 0.251, alpha: 1)
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.cornerRadius = 20
    
        self.setTitle(setTitle, for: .normal)
    
}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
