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
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: SystemImage.addNewContact, style: .done, target: self, action: #selector(didTapNewContacts))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(tapEdit))
        navigationController?.navigationBar.tintColor = UIColor.blue
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
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .link
        
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
        
        DatabaseManager.shared.fetchChats(uid: uid!) { chats in
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
        cell.backgroundColor = .white
        let chat = chats[indexPath.row]
        let otherUser = chat.users[chat.otherUser!]
        cell.animateCell(show: tapped)
        cell.lable1.text = otherUser.username
        cell.lable2.text = chat.lastMessage?.message
        
        let formattedDate = DateFormatter()
        formattedDate.dateFormat = "hh:mm:a"
        
        if chat.lastMessage == nil {
            cell.timelable.isHidden = true
        } else {
            
            cell.timelable.isHidden = false
            cell.timelable.text = formattedDate.string(from: chat.lastMessage!.time)
        }
        
        StorageManager.shared.downloadImageWithPath(path: "Profile/\(otherUser.uid)") { image in
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
        return CGSize(width: view.frame.width, height: 100)
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
