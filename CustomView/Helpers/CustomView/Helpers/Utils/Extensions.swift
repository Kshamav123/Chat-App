//
//  Extensions.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 16/11/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: "ok", style: .default) { (okClicked) in
        }
        alert.addAction(ok)
        self.present(alert, animated: true)
    }
    
}
