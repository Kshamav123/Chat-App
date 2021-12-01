//
//  ChatViewController.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 16/11/21.
//

import UIKit

class ChatViewController: UITableViewController  {
    
    //MARK: Properties
    
    var chat: Chats!
    var messages = [Message]()
    var currentUser : UserData!
    var otherUser: UserData!
    var chatId: String!
    
    let textField = CustomTextField(placeholder: "  Message")
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrowtriangle.right.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .link
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    let photoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo.artframe"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .link
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(clickPhotoButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var inputContainerView: UIView = {
        
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 60)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .clear
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = .tertiarySystemBackground
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -5).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        containerView.addSubview(textField)
        
        textField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 10).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10).isActive = true
        
        containerView.addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        containerView.addSubview(photoButton)
        photoButton.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -5).isActive = true
        photoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        photoButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        textField.rightAnchor.constraint(equalTo: photoButton.leftAnchor, constant: -5).isActive = true
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        
        return true
    }
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureTableView()
        configure()
        fetchingChats()
        //        configureNotificationObserver()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
    }
    
    //MARK: Actions
    
    @objc func keyboardWillShow(){
        
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 320
        }
    }
    
    @objc func keyboardWillHide(){
        
        if view.frame.origin.y == -320{
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func sendMessage() {
        
        if textField.text != "" {
            
            let newMessage = Message(sender: currentUser.uid, message: textField.text!, time: Date(), seen: false)
            messages.append(newMessage)
            chat.lastMessage = newMessage
            DatabaseManager.shared.addMessage(chat: chat!, id: chatId, messageContent: messages)
            textField.text = ""
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    @objc func clickPhotoButton() {
        
    }
    
    //MARK: Helpers
    
    func configureNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func configure() {
        
        chatId = "\(chat.users[0].uid)_\(chat.users[1].uid)"
        
        if chat.otherUser == 0 {
            otherUser = chat.users[0]
            currentUser = chat.users[1]
        } else {
            otherUser = chat.users[1]
            currentUser = chat.users[0]
        }
        navigationItem.title = otherUser.username
    }
    
    func configureTableView() {
        
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 70 , right: 0)
        tableView.separatorStyle = .none
        tableView.register(ChatCell.self, forCellReuseIdentifier: "cell")
        tableView.alwaysBounceVertical = true
    }
    
    func fetchingChats() {
        
        messages = []
        DatabaseManager.shared.fetchMessages(chatId: chat.chatId!) { messages in
            print(messages)
            self.messages = messages
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatCell
        
        let messageItem : Message = messages[indexPath.row]
        cell.message1 = messageItem
        cell.message.text = messageItem.message
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}


