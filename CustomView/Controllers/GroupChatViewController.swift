//
//  GroupChatViewController.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 06/12/21.
//

import UIKit
import FirebaseAuth

protocol GroupChatControllerDelegate: AnyObject {
    
    func controllerGroup(wantsToStartChatWith chat: Chats)
}

class GroupChatViewController: UIViewController {
    
    //    let cellIdentifier = "groupCell"
    var currentUser: UserData!
    var users: [UserData] = []
    var collectionView: UICollectionView!
    var selectedUsers: [IndexPath] = []
    var uid :String = FirebaseAuth.Auth.auth().currentUser!.uid
    weak var delegate: GroupChatControllerDelegate?
    
    let groupPhoto : UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.tintColor = UIColor(red: 0.616, green: 0.647, blue: 0.675, alpha: 1)
        imageView.clipsToBounds = true
        imageView.image = SystemImage.groupPhoto
        imageView.layer.cornerRadius = 40
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = UIColor(red: 0.137, green: 0.176, blue: 0.212, alpha: 1)
        
        return imageView
    }()
    
    let groupNameTextField = CustomTextField(placeholder: "")
    
    lazy var groupNameContainer: InputContainerView = {
        
        groupNameTextField.textColor = UIColor(red: 0.655, green: 0.675, blue: 0.69, alpha: 1)
        groupNameTextField.attributedPlaceholder = NSAttributedString(string: "Enter the group name", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.655, green: 0.675, blue: 0.69, alpha: 1)])
        return InputContainerView(image: SystemImage.personImage!, textField: groupNameTextField, backgroundColor: UIColor(red: 0.176, green: 0.22, blue: 0.243, alpha: 1))
        
    }()
   
    override func viewDidLoad() {

        super.viewDidLoad()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
        groupPhoto.addGestureRecognizer(gesture)
        configureCollectionView()
        configureUI()
        fetchAllUsers()
        configureNavigationBar()
        
    }
   
    func presentPhotoActionSheet() {
        
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How will you select a picture", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
            
        }))
        
        present(actionSheet,animated: true)
        
    }
    
    func presentPhotoPicker() {
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
        
    }
    
    func configureUI() {
        
        view.addSubview(groupPhoto)
        view.addSubview(groupNameContainer)
        view.addSubview(collectionView)
        
        view.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)

        groupPhoto.translatesAutoresizingMaskIntoConstraints = false
        groupNameContainer.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            groupPhoto.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            groupPhoto.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            groupPhoto.heightAnchor.constraint(equalToConstant: 100),
            groupPhoto.widthAnchor.constraint(equalToConstant: 100),
            
            groupNameContainer.topAnchor.constraint(equalTo: groupPhoto.bottomAnchor, constant: 10),
            groupNameContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            groupNameContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: groupNameContainer.bottomAnchor, constant: 20),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func configureCollectionView() {
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        //               view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ConversationCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)

    }
    
    func fetchAllUsers() {
        DatabaseManager.shared.fetchAllUsers(uid: uid) { users in
            self.users = users
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func handleCreateButton() {
        
        let chatID = "\(groupNameTextField.text!)_\(UUID())"
        let groupPhotoPath = "Profile/\(chatID)"
        var usersList: [UserData] = []
        usersList.append(currentUser)
        
        for indexPath in selectedUsers {
            let user = users[indexPath.row]
            usersList.append(user)
        }
        StorageManager.ImageUploader.uploadImage(image: groupPhoto.image!, uid: chatID){ url in
            
        }
        DatabaseManager.shared.addChat1(users: usersList, id: chatID, isGroupChat: true, groupName: groupNameTextField.text, groupIconPath: groupPhotoPath)
        
        let vc = ChatViewController()
        let chat = Chats(users: usersList, lastMessage: nil, messages: [], chatId: chatID, isGroupChat: true, groupName: groupNameTextField.text, groupIconPath: groupPhotoPath)
        delegate?.controllerGroup(wantsToStartChatWith: chat)
    }
    
    @objc func didTapProfilePic() {
        
        presentPhotoActionSheet()
        
    }
    
    @objc func cancelTapped(){
        
        dismiss(animated: true, completion: nil)
    }
    
    func configureNavigationBar() {
        
        let createGroup = UIBarButtonItem(title: "Create", style: .done, target: self, action: #selector(handleCreateButton))
        
        let cancels = UIBarButtonItem(image: UIImage(systemName:"delete.backward.fill"), style: .done, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItems = [cancels, createGroup]
        navigationController?.navigationBar.tintColor = UIColor(red: 0.616, green: 0.647, blue: 0.675, alpha: 1)
    }
    
}

extension GroupChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard  let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.groupPhoto.image = selectedImage
        return
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        return
    }
    
}

extension GroupChatViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ConversationCell
        
        let user = users[indexPath.row]
        cell.lable1.text = user.username
        cell.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
        cell.timelable.isHidden = true
        StorageManager.shared.downloadImageWithPath(path: "Profile/\(user.uid)") { image in
            cell.imageView.image = image
            
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedCell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        
        if selectedUsers.contains(indexPath){
            selectedUsers.remove(at: selectedUsers.firstIndex(of: indexPath)!)
        }else {
            selectedUsers.append(indexPath)
            selectedCell.backgroundColor = UIColor(red: 0.137, green: 0.176, blue: 0.212, alpha: 1)
        }
        
    }
    
}
extension GroupChatViewController :UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    
}

