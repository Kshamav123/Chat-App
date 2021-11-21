//
//  ChatViewController.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 16/11/21.
//

import UIKit

class ChatViewController: UITableViewController  {
    
    var chat: Chats!
    
    //    var tableView: UITableView!
    var messages = [Message]()
    var currentUser : UserData!
    var otherUser: UserData!
    var chatId: String?
    
    
    let textField = CustomTextField(placeholder: "  Message")
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .link
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        return button
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureTableView()
        fetchingChats()
        configure()
        configureNotificationObserver()
    }
    
    func configureNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(){
//        print("Keybaord will show")
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 70
        }
    }
    
    @objc func keyboardWillHide(){
//        print("Keybaord will hide")
        if view.frame.origin.y == -70 {
            self.view.frame.origin.y = 0
        }
    }
    
    
    func configure() {
        
        chatId = "\(chat.users[0].uid)_\(chat.users[1].uid)"
        
        view.addSubview(textField)
        view.addSubview(sendButton)
        
        textField.layer.cornerRadius = 10
//        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.gray.cgColor
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            textField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
            textField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            textField.heightAnchor.constraint(equalToConstant: 50),
            textField.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -70),
            textField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -5),
            
            sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
            sendButton.heightAnchor.constraint(equalToConstant: 50),
            sendButton.widthAnchor.constraint(equalToConstant: 50),
            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            
            
        ])
    }
    
    @objc func sendMessage() {
        
        if textField.text != "" {
            
            let newMessage = Message(sender: currentUser.uid, message: textField.text!, time: Date(), seen: false)
            chat.messages?.append(newMessage)
            chat.lastMessage = newMessage
            DatabaseManager.shared.addMessage(chat: chat!, id: chatId!)
            textField.text = ""
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    func configureTableView() {

        
        tableView.separatorStyle = .none
        tableView.register(ChatCell.self, forCellReuseIdentifier: "cell")
    }
    
    func fetchingChats() {
        
        messages = []
        DatabaseManager.shared.fetchMessages(chatId: chat.chatId!) { messages in
            print("fffffffffffffffffffff")
//            print(messages)
            print(self.chat.chatId)
            self.messages = messages
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        print(messages.count)
//        return messages.count
//    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatCell
        
        let messageItem : Message = messages[indexPath.row]
        cell.message1 = messageItem
        cell.message.text = messageItem.message
//        cell.backgroundColor = .red
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
      }
}


