//
//  Messages.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 18/11/21.
//

import Foundation

struct Message {
    var sender: String
    var message: String
    var time: Date
    var seen: Bool
    var dateString: String?
    var imagePath: String?
       
       var dictionary: [String: Any] {
           return [
               "sender": sender,
               "message": message,
               "time": dateString!,
               "seen": seen,
               "imagePath": imagePath
           ]
       }
    
}
