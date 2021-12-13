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
        textColor = UIColor(red: 0.655, green: 0.675, blue: 0.69, alpha: 1)
        backgroundColor = UIColor(red: 0.176, green: 0.22, blue: 0.243, alpha: 1)
//        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.655, green: 0.675, blue: 0.69, alpha: 1)])
        self.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
