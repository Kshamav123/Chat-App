//
//  NewContactsViewController.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 16/11/21.
//

import UIKit
import FirebaseAuth


class NewContactsViewController: UIViewController, UICollectionViewDelegate {
        
        var chats: [Chats] = []
        var results: [UserData] = []
        var users: [UserData] = []
        var currentUser: UserData?
        var hasFetched = false
        var collectionView: UICollectionView!
        var uid :String = FirebaseAuth.Auth.auth().currentUser!.uid
    
    override func viewDidLoad() {
            super.viewDidLoad()
        searchBar.delegate = self
        configureUI()
        configureCollectionView()
        fetchAllUser()
    }
    
   let searchBar :UISearchBar = {
           let bar = UISearchBar()
            bar.placeholder = "Search the contacts"
            return bar
        }()
    
    let noResultLabel:UILabel = {
           let label = UILabel()
           label.text = "no results"
           label.textAlignment = .center
           label.textColor = .label
           label.font = .systemFont(ofSize: 21, weight: .medium)
           label.isHidden = true
           return label
    }()
    
    func configureUI() {
        searchBar.delegate = self
           view.backgroundColor = .white
//           navigationItem.title = "Select User"
        navigationItem.backButtonTitle = ""
        let cancel = UIBarButtonItem(title: "cancel", style: .done, target: self, action: #selector(cancelTapped))

        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItems = [cancel]
       }
    
    func configureCollectionView() {
            collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(noResultLabel)
            view.addSubview(collectionView)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(ConversationCell.self, forCellWithReuseIdentifier: "cell")
        }
    
    func fetchAllUser() {
            DatabaseManager.shared.fetchAllUsers(uid: uid) { users in
                self.users = users
                print(users)
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    
    @objc func cancelTapped() {
        
        dismiss(animated: true, completion: nil)
    }
//
//    @objc func searchTapped() {
//
//
//    }
}

extension NewContactsViewController:UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ConversationCell
        let user = users[indexPath.row]
        cell.lable1.text = user.username
//        cell.timelable.isHidden = true
        cell.selectButton.isHidden = true
        
        let uid = user.uid
        
        StorageManager.shared.downloadImageWithPath(path: "Profile/\(uid)") { image in
            cell.imageView.image = image
           
            
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedUser = users[indexPath.row]
        let users: [UserData] = [currentUser!, selectedUser]
        print(currentUser)
        let id = "\(currentUser!.uid)_\(selectedUser.uid)"
        let vc = ChatViewController()
        for chat in chats {
        var currentChat = chat
              let uid1 = chat.users[0].uid
              let uid2 = chat.users[1].uid
              if uid1 == currentUser!.uid && uid2 == selectedUser.uid || uid1 == selectedUser.uid && uid2 == currentUser!.uid {
                print("Already Chated")
                currentChat.otherUser = uid1 == currentUser!.uid ? 1 : 0
                vc.chat = currentChat
                navigationController?.pushViewController(vc, animated: true)
                return
              }
        }
        DatabaseManager.shared.addChat(user1: currentUser!, user2: selectedUser, id: id)
        vc.chat = Chats(users: users, lastMessage: nil, messages: [], otherUser: 1, chatId: id)
        navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true, completion: nil)
            }
            
        }
        
 
           


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
    extension NewContactsViewController : UISearchBarDelegate {
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            print("DDDDDDDDDDDDDDDDDDDDDD")
              guard let text = searchBar.text,!text.replacingOccurrences(of: " ", with: "").isEmpty else {
                  
                  return
              }
            searchBar.resignFirstResponder()
              results.removeAll()
              self.searchUsers(query:text)
          }
        
        func searchUsers(query:String) {
               
               if hasFetched {
                   filterUsers(term: query)
               }else{
                   let uid = Auth.auth().currentUser?.uid
                    DatabaseManager.shared.fetchAllUsers(uid: uid!) { users in
                        self.users = users
                        self.hasFetched = true
                        print(self.users)
                        self.filterUsers(term: query)
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }

               }
           }
        
        func filterUsers(term:String) {
                guard hasFetched else {
                    return
                }
             
                print(self.users)
            self.results = self.users.filter({$0.username.lowercased() == term.lowercased()
                    
            })
                print(results)
                updateUI()
            }
        
        func updateUI(){
               if results.isEmpty {
                   self.collectionView.isHidden = true
                   self.noResultLabel.isHidden = false
               }else{
                   self.collectionView.isHidden = false
                   self.noResultLabel.isHidden = true
               }
               self.collectionView.reloadData()
           }
    }

