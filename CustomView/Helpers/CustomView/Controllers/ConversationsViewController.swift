//
//  ConversationsViewController.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 13/11/21.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {
    
    let tableView: UITableView = {
        
        let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
        
    }()
    
    let noConversationLabel: UILabel = {
        
        let label = UILabel()
        label.text = "No Chat"
        label.textAlignment = .center
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 21)
        label.isHidden = true
        return label
    }()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "person.badge.plus"), style: .done, target: self, action: #selector(didTapNewContacts))
        navigationController?.navigationBar.tintColor = UIColor.green
        view.addSubview(tableView)
        view.addSubview(noConversationLabel)
        setUpTableView()
        fetchConversations()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validateAuth()
    }
    
    //MARK: Actions
    
    @objc func didTapNewContacts() {
        
        let vc = NewContactsViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    
    //MARK: Helpers
    
    func fetchConversations() {
        
        tableView.isHidden = false
        
    }
    
    func validateAuth() {
        
        if FirebaseAuth.Auth.auth().currentUser == nil {
            
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
        }
        
    }
    
    func setUpTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension ConversationsViewController :UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "hello"
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = ChatViewController()
        vc.title = "Abc"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
