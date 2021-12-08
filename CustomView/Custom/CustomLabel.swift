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
        textColor = .black
        self.font = font

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
