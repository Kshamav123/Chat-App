//
//  CustomTextField.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 11/11/21.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String) {
        super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: 18)
        adjustsFontSizeToFitWidth = true
        minimumFontSize = 12
        autocorrectionType = .no
        textColor = .black
        backgroundColor = .white
        layer.cornerRadius = 10
        layer.borderColor = UIColor.darkGray.cgColor
//        layer.borderWidth = 2
        self.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
