//
//  Validation.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 17/11/21.
//

import Foundation

class Validation {
    
    
  static  func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
      
        
     static func isEmailValid(_ email : String) -> Bool{
            let emailTest = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}")
            return emailTest.evaluate(with: email)
            
        }
}
