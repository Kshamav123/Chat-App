//
//  NewContactsViewController.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 16/11/21.
//

import UIKit
import FirebaseAuth

protocol MessageControllerDelegate: AnyObject {
    
    func controller(_ controller : NewContactsViewController, wantsToStartChatWith chat: Chats)
}

class NewContactsViewController: UIViewController, UICollectionViewDelegate {
    
    //MARK: Properties
    
    var chats: [Chats] = []
    var results: [UserData] = []
    var users: [UserData] = []
    var currentUser: UserData?
    var hasFetched = false
    weak var delegate: MessageControllerDelegate?
    var collectionView: UICollectionView!
    var uid :String = FirebaseAuth.Auth.auth().currentUser!.uid
    var searching : Bool = false
    let searchController = UISearchController(searchResultsController: nil)
 
//    let noResultLabel:UILabel = {
//        let label = UILabel()
//        label.text = "no results"
//        label.textAlignment = .center
//        label.textColor = .label
//        label.font = .systemFont(ofSize: 21, weight: .medium)
//        label.isHidden = true
//        return label
//    }()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureCollectionView()
        configureSearchBar()
        fetchAllUser()
    }
    
    //MARK: Helpers
    
    func configureUI() {
        
        view.backgroundColor = .white
        navigationItem.backButtonTitle = ""
        let cancel = UIBarButtonItem(title: "cancel", style: .done, target: self, action: #selector(cancelTapped))
        navigationItem.rightBarButtonItems = [cancel]
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
//        view.addSubview(noResultLabel)
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ConversationCell.self, forCellWithReuseIdentifier: "cell")
    }
    
    func fetchAllUser() {
        
        DatabaseManager.shared.fetchAllUsers(uid: uid) { users in
            self.users = users
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func configureSearchBar(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    //MARK: Actions
    
    @objc func cancelTapped() {
        
        dismiss(animated: true, completion: nil)
    }
}

//MARK: UICollectionViewDataSource

extension NewContactsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = searching ? results.count : users.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ConversationCell
        let user = searching ? results[indexPath.row] : users[indexPath.row]
        cell.lable1.text = user.username
        cell.timelable.isHidden = true
        cell.selectButton.isHidden = true
        
        let uid = user.uid
        
        StorageManager.shared.downloadImageWithPath(path: "Profile/\(uid)") { image in
            cell.imageView.image = image
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("selected")
        let selectedUser = searching ? results[indexPath.row] : users[indexPath.row]
        let users: [UserData] = [currentUser!, selectedUser]
        
        let id = "\(currentUser!.uid)_\(selectedUser.uid)"
        let vc = ChatViewController()
        
        
        for chat in chats {
            if chat.isGroupChat! { continue }
            var currentChat = chat
            let uid1 = chat.users[0].uid
            let uid2 = chat.users[1].uid
            if uid1 == currentUser!.uid && uid2 == selectedUser.uid || uid1 == selectedUser.uid && uid2 == currentUser!.uid {
                currentChat.otherUser = uid1 == currentUser!.uid ? 1 : 0
                delegate?.controller(self, wantsToStartChatWith: currentChat)
                return
            }
        }
//        DatabaseManager.shared.addChat(user1: currentUser!, user2: selectedUser, id: id)
        DatabaseManager.shared.addChat1(users: [currentUser!,selectedUser], id: id, isGroupChat: false, groupName: "", groupIconPath: "")
//        var chat = Chats(users: users, lastMessage: nil, messages: [], otherUser: 1, chatId: id)
        var chat = Chats(users: users, lastMessage: nil, messages: [], otherUser: 1, chatId: id, isGroupChat: false)
        delegate?.controller(self, wantsToStartChatWith: chat)
    }
    
}

//MARK: UICollectionViewDelegateFlowLayout

extension NewContactsViewController :UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: UISearchBarDelegate, UISearchResultsUpdating

extension NewContactsViewController: UISearchBarDelegate, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        let count = searchController.searchBar.text?.count
        let searchText = searchController.searchBar.text!
        if !searchText.isEmpty {
            searching = true
            results.removeAll()
            results = users.filter({$0.username.prefix(count!).lowercased() == searchText.lowercased()})
            print(results)
        }
        else{
            searching = false
            results = users
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        results = users
        collectionView.reloadData()
    }
}

