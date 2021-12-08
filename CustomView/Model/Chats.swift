//
//  Chats.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 18/11/21.
//

import Foundation

struct Chats {
    
    var users: [UserData]
    var lastMessage: Message?
    var messages: [Message]?
    var otherUser: Int?
    var chatId: String?
    var isGroupChat: Bool?
    var groupName: String?
    var groupIconPath: String?
    
}
