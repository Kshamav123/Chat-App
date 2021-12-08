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
    //    var chatId: String!
    let uid = DatabaseManager.shared.getUID()
    
    let textField = CustomTextField(placeholder: Placeholder.message)
    
    let sendButton: UIButton = {
        let button = UIButton()
        button.setImage(SystemImage.send, for: .normal)
        button.tintColor = .white
        button.backgroundColor = .link
        button.layer.cornerRadius = 25
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
        
    }()
    
    let photoButton: UIButton = {
        let button = UIButton()
        button.setImage(SystemImage.photo, for: .normal)
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
            
            let newMessage = Message(sender: currentUser.uid, message: textField.text!, time: Date(), seen: false, imagePath: "")
            messages.append(newMessage)
            chat.lastMessage = newMessage
            DatabaseManager.shared.addMessage(chat: chat!, id: chat.chatId!, messageContent: messages)
            textField.text = ""
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    @objc func clickPhotoButton() {
        
        presentPhotoActionSheet()
    }
    
    //MARK: Helpers
    
    func configureNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    func configure() {
        
        var name: String
        
        DatabaseManager.shared.fetchUser(uid: uid!, completion: { user in
            self.currentUser = user
        })
        
        if chat.isGroupChat! {
            name = chat.groupName!
        }else {
            if chat.users[0].uid == uid {
                name = chat.users[1].username
            } else {
                name = chat.users[0].username
            }
        }
        
        navigationItem.title = name
    }
    
    
    func configureTableView() {
        
        tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 70 , right: 0)
        tableView.separatorStyle = .none
        tableView.register(ChatCell.self, forCellReuseIdentifier: "cell")
        tableView.register(ImageCell.self, forCellReuseIdentifier: "Imagecell")
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
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile picture", message: "How would like to select a picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentPhotoLibrary() {
        let vc =  UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    
    func sendPhoto(img: UIImage) {
        
        let path = "MessageImages/\(NSUUID().uuidString)"
        let newMessage = Message(sender: self.currentUser.uid, message: "", time: Date(), seen: false, imagePath: path)
        messages.append(newMessage)
        chat.lastMessage = newMessage
        StorageManager.shared.uploadMessageImage(image: img, path: path) { url in
            
        }
        DatabaseManager.shared.addMessage(chat: self.chat, id: self.chat.chatId!, messageContent: self.messages)
        self.tableView.reloadData()
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if messages[indexPath.row].imagePath == "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatCell
            
            let messageItem : Message = messages[indexPath.row]
            cell.message1 = messageItem
            cell.message.text = messageItem.message
            cell.userList = chat.users
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "Imagecell", for: indexPath) as! ImageCell
            cell.message1 = messages[indexPath.row]
            cell.userList = chat.users
            StorageManager.shared.downloadImageWithPath(path: messages[indexPath.row].imagePath!, completion: { image in
                DispatchQueue.main.async {
                    cell.messageImage.image = image
                }
            })
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        sendPhoto(img:selectedImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
