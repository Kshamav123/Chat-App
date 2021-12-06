//
//  Constants.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 24/11/21.
//

import Foundation
import UIKit

struct Font {
    static let fontBold1 = UIFont.boldSystemFont(ofSize: 20)
    
    static let font1 = UIFont.systemFont(ofSize: 16)
    static let font2 = UIFont.systemFont(ofSize: 16, weight: .medium)
    static let font3 = UIFont.systemFont(ofSize: 12, weight: .light)
    static let font4 = UIFont.systemFont(ofSize: 10,weight: .light)
   
}

struct Placeholder {
    
    static let email = "   Email"
    static let password = "   Password"
    static let firstName = "   First Name"
    static let lastName = "   Last Name"
    static let message = " Message"
}

struct ButtonSetTitle {
    
    static let signUp = CustomButton(setTitle: "Sign Up")
    static let login = CustomButton(setTitle: "Login")
    static let forgotPassword = CustomButton(setTitle: "Forgot Password")
    static let resetPassword = CustomButton(setTitle: "Reset Password")
    static let backToLogin = CustomButton(setTitle: "Back To Login")
    
}

struct SystemImage {
    
    static let email = UIImage(systemName: "envelope")
    static let password = UIImage(systemName: "lock")
    static let personImage = UIImage(systemName: "person.fill")
    static let send = UIImage(systemName: "arrowtriangle.right.fill")
    static let addNewContact = UIImage(systemName: "person.badge.plus")
    static let photo = UIImage(systemName: "photo.artframe")
}
