//
//  CustomLabel.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 05/12/21.
//

import Foundation
import UIKit

class CustomLabel: UILabel {
    
    init(font: UIFont) {
        super.init(frame: .zero)
//        self.text = text
        textColor = .black
        self.font = font
//        textAlignment = .center
//        numberOfLines = 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
