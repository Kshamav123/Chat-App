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
        backgroundColor = .darkGray
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.cornerRadius = 20
        self.setTitle(setTitle, for: .normal)
    
}
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
