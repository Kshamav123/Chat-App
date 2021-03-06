//
//  ViewController.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 09/11/21.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    //MARK: Properties
    
    var chats: [Chats] = []
    var currentUser: UserData?
    var collectionView: UICollectionView!
    var tapped :Bool = false
    var initialFetch: Bool = false
    var uid : String!
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addNewContact = UIBarButtonItem(image: SystemImage.addNewContact, style: .done, target: self, action: #selector(didTapNewContacts))
        let groupChat = UIBarButtonItem(title: "New Group", style: .done, target: self, action: #selector(didTapGroupChat))
        navigationItem.rightBarButtonItems = [addNewContact, groupChat]
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(tapEdit))
        navigationController?.navigationBar.tintColor = UIColor(red: 0.616, green: 0.647, blue: 0.675, alpha: 1)
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isLoggedIn()
    }
    
    //MARK: Actions
    
    @objc func tapEdit() {
        
        tapped = !tapped
        collectionView.reloadData()
    }
    
    @objc func didTapNewContacts() {
        
        let vc = NewContactsViewController()
        vc.currentUser = currentUser
        let nav = UINavigationController(rootViewController: vc)
        vc.delegate = self
        vc.chats = chats
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    @objc func didTapGroupChat() {
        
        let vc = GroupChatViewController()
        vc.currentUser = currentUser
        let nav = UINavigationController(rootViewController: vc)
        vc.delegate = self
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
                
    }
    
    //MARK: Helpers
    
    func isLoggedIn() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let vc = LoginViewController()
                vc.delegate = self
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        } else {
            configureNavigationBar()
            configureUICollectionView()
            fetchData()
        }
    }
    
    func configureNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 0.616, green: 0.647, blue: 0.675, alpha: 1)]
        appearance.backgroundColor = UIColor(red: 0.137, green: 0.176, blue: 0.212, alpha: 1)
        navigationItem.title = "ChatApp"
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func configureUICollectionView() {
        
        uid = Auth.auth().currentUser?.uid
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ConversationCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.layer.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1).cgColor
    }
    
    func validateAuth() {
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        }
    }
    
    func fetchData() {
        
        chats = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        
        DatabaseManager.shared.fetchUser(uid: uid!) { currentUser in
            
            self.currentUser = currentUser
        }
        
        DatabaseManager.shared.fetchChats1(uid: uid!) { chats in
            self.chats = chats
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }
    
}

//MARK: UICollectionViewDelegate

extension ViewController : UICollectionViewDelegate {
    
}

//MARK: UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return chats.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ConversationCell
        cell.layer.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1).cgColor
        let chat = chats[indexPath.row]
       
        cell.animateCell(show: tapped)
       
        cell.lable2.text = chat.lastMessage?.message
        
        let formattedDate = DateFormatter()
        formattedDate.dateFormat = "hh:mm:a"
        
        if chat.lastMessage == nil {
            cell.timelable.isHidden = true
        } else {
            
            cell.timelable.isHidden = false
            cell.timelable.text = formattedDate.string(from: chat.lastMessage!.time)
        }
        var path : String
        if chat.isGroupChat! {
            path = chat.groupIconPath!
            cell.lable1.text = chat.groupName
            
        }else{
            
        let otherUser = chat.users[chat.otherUser!]
        path = "Profile/\(otherUser.uid)"
        cell.lable1.text = otherUser.username
        }
        StorageManager.shared.downloadImageWithPath(path: path) { image in
            cell.imageView.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let vc = ChatViewController()
        vc.currentUser = currentUser
        vc.chat = chats[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: UICollectionViewDelegateFlowLayout

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}

//MARK: UserAuthenticatedDelegate

extension ViewController: UserAuthenticatedDelegate {
    func UserAuthenticated() {
        configureNavigationBar()
        configureUICollectionView()
        fetchData()
    }
}

//MARK: MessageControllerDelegate

extension ViewController: MessageControllerDelegate {
    func controller(_ controller: NewContactsViewController, wantsToStartChatWith chat: Chats) {
        
        controller.dismiss(animated: true, completion: nil)
        
        let vc = ChatViewController()
        vc.chat = chat
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.largeTitleDisplayMode = .never
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ViewController: GroupChatControllerDelegate {
    func controllerGroup(wantsToStartChatWith chat: Chats) {
        dismiss(animated: true, completion: nil)
        
        let vc = ChatViewController()
        vc.chat = chat
        vc.hidesBottomBarWhenPushed = true
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

