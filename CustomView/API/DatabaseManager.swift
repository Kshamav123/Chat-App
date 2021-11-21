//
//  DatabaseManager.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 15/11/21.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

class DatabaseManager {
    
    static let shared = DatabaseManager()
    let database =  Database.database().reference()
    
//    static func safeEmail(emailAddress: String) -> String {
//        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
//        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
//        return safeEmail
//    }
    
    let databaseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    func userExists(with email: String, completion: @escaping((Bool) -> Void)) {
        
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
        guard snapshot.value  as? String != nil else {
        completion(false)
                return
            }
            
            completion(true)
        })
    }

    
    func addUser(user: UserData) {
               database.child("Users").child(user.uid).setValue(user.dictionary)
           }
    
//    enum DatabaseError: Error {
//        case failedToFetch
//    }
    
    func fetchUser(uid: String, completion: @escaping(UserData) -> Void) {
           database.child("Users").child(uid).observe(.value) { snapshot in
               if let dictionary = snapshot.value as? [String: Any] {
                   
   //                print(dictionary)
                   let email = dictionary["email"] as! String
                   let username = dictionary["username"] as! String
                   let profileURL = dictionary["profileURL"] as! String
                   let uid = dictionary["uid"] as! String

                   let user = UserData(username: username, email: email, profileURL: profileURL, uid: uid)
                   completion(user)
               }
           }
       }
    
    func fetchAllUsers(uid: String, completion: @escaping([UserData]) -> Void) {
               print("wdwewedwef")
               
               var users = [UserData]()
               
               database.child("Users").observe(.value) { snapshot in
                   if let result = snapshot.value as? [String: Any] {
       //                print(result)
                       for userid in result.keys {
                           if userid == uid {
                               continue
                           }
                           let userData = result[userid] as! [String: Any]
                           
                           let email = userData["email"] as! String
                           let username = userData["username"] as! String
                           let uid = userData["uid"] as! String
                           let profileURL = userData["profileURL"] as! String
                           let user = UserData(username: username, email: email, profileURL: profileURL, uid: uid)
                           users.append(user)
                       }
                       completion(users)
                   }
               }
               
           }
    
    func addChat(user1: UserData, user2: UserData, id: String) {
               var userDictionary: [[String: Any]] = []
               
               userDictionary.append(user1.dictionary)
               userDictionary.append(user2.dictionary)
               let finalDic = ["users" : userDictionary]

              database.child("Chats").child(id).setValue(finalDic)
           }
    
    public func onLogout() ->Bool{
            
            do {
                try Auth.auth().signOut()
                return true
            }catch{
                return false
            }
        }
    
    func getUID() -> String? {
           return Auth.auth().currentUser?.uid
       }
    
    func fetchChats(uid: String, completion: @escaping([Chats]) -> Void) {
               
               database.child("Chats").observe(.value) { snapshot in
                   var chats = [Chats]()
                   print("//////////////////////////")
                   if let result = snapshot.value as? [String: [String: Any]] {
       //                print(result)
                       for key in result.keys {
       //                   print(key)
                           let value = result[key]!
                       var messagesArray: [Message] = []
                           var lastMessage: Message?
                           
                           let users = value["users"] as! [[String: Any]]
                           let lastMessageDictionary = value["lastMessage"] as? [String: Any]
                           let messagesDictionary = value["messagesArray"] as? [[String: Any]]
       //                    print(users)
                           if lastMessageDictionary != nil {
                               for messageItem in messagesDictionary! {
                                   let sender = messageItem["sender"] as! String
                                   let message = messageItem["message"] as! String
                                   let timeString = messageItem["time"] as! String
                                   let seen = messageItem["seen"] as! Bool
                                   
                                   let time = self.databaseDateFormatter.date(from: timeString)
                                   
                                   let currentMessage = Message(sender: sender, message: message, time: time!, seen: seen)
                                   
                                   messagesArray.append(currentMessage)
                               }
                               
                               let sender = lastMessageDictionary!["sender"] as! String
                               let message = lastMessageDictionary!["message"] as! String
                               let timeString = lastMessageDictionary!["time"] as! String
                               let seen = lastMessageDictionary!["seen"] as! Bool
                               
                               let time = self.databaseDateFormatter.date(from: timeString)
                               
                               lastMessage = Message(sender: sender, message: message, time: time!, seen: seen)
                               
                           } else {
                               messagesArray = []
                               lastMessage = nil
                           }
                           
                           let user1 = users[0]
                           let user2 = users[1]
                           
                           let email1 = user1["email"] as! String
                           let username1 = user1["username"] as! String
                           let uid1 = user1["uid"] as! String
                           let profileURL1 = user1["profileURL"] as! String
                           
                           let firstUser = UserData(username: username1, email: email1, profileURL: profileURL1, uid: uid1)
                           
                           let email2 = user2["email"] as! String
                           let username2 = user2["username"] as! String
                           let uid2 = user2["uid"] as! String
                           let profileURL2 = user2["profileURL"] as! String
                           
                           let secondUser = UserData(username: username2, email: email2, profileURL: profileURL2, uid: uid2)
                           
                           var otherUser: Int
                           
                           if uid1 == uid {
                               otherUser = 1
                           } else {
                               otherUser = 0
                           }
                           let id = key
                           let chat = Chats(users: [firstUser, secondUser], lastMessage: lastMessage, messages: messagesArray, otherUser: otherUser, chatId: id)
                           
                           if firstUser.uid == uid || secondUser.uid == uid {
                               chats.append(chat)
                           }
                           
                           print(chat)
                                           
     
                       }
                       completion(chats)
                   }
               }
           }
    func fetchMessages(chatId: String, completion: @escaping([Message]) -> Void) {
        
           database.child("Chats").child("\(chatId)/messagesArray").observe(.value) { snapshot in
               var resultArray: [Message] = []
               
               if let result = snapshot.value as? [[String: Any]] {

                   for message in result {
  
                       resultArray.append(self.createMessageObject(dictionary: message))
                   }
                   
                   completion(resultArray)
               }
           }
       }
    
    func createMessageObject(dictionary: [String: Any]) -> Message {
             let sender = dictionary["sender"] as! String
             let message = dictionary["message"] as! String
             let timeString = dictionary["time"] as! String
             let seen = dictionary["seen"] as! Bool
             
             let time = databaseDateFormatter.date(from: timeString)
             
             return Message(sender: sender, message: message, time: time!, seen: seen)
         }
    
    func addMessage(chat: Chats, id: String) {
               
               var currentChat = chat
               
               let dateString = databaseDateFormatter.string(from: currentChat.lastMessage!.time)
               currentChat.lastMessage?.dateString = dateString
               
               let lastMessageDictionary = currentChat.lastMessage?.dictionary
               var messagesDictionary: [[String: Any]] = []
               
        for var message in currentChat.messages! {
                   let dateString = databaseDateFormatter.string(from: message.time)
                   message.dateString = dateString
                   messagesDictionary.append(message.dictionary)
               }
   
               let finalDictionary = ["lastMessage": lastMessageDictionary!,
                                      "messagesArray": messagesDictionary] as [String : Any]
      
               database.child("Chats").child(id).updateChildValues(finalDictionary)
           }
 }
    

    
    struct UserData: Codable {

        var username: String
        var email: String
        var profileURL: String
        var uid: String

        var dictionary: [String: Any] {
            return [
                "username": username,
                "email": email,
                "profileURL": profileURL,
                "uid": uid
            ]
        }
    }
    
    


