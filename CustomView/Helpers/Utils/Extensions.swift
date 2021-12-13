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

extension UIButton {
    
    func pulsanate() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.2
        pulse.fromValue = 0.95
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        pulse.damping = 0.5
        layer.add(pulse, forKey: nil)
    }
    
    func flash(){
        
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        layer.add(flash, forKey: nil)
    }
    
    func shake() {
        
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 1
        shake.autoreverses = true
        
        let point = CGPoint(x: center.x - 5, y: center.y)
        let value = NSValue(cgPoint: point)
        shake.fromValue = value
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        shake.toValue = toValue
        layer.add(shake, forKey: nil)
        
    }
    
}
