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
        textColor =  UIColor(red: 0.831, green: 0.863, blue: 0.875, alpha: 1)
        self.font = font

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
