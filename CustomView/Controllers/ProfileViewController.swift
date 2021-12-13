//
//  ProfileViewController.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 15/11/21.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet var tableView: UITableView!
    
    var imageView: UIImageView!
    let content = ["Logout"]
    var currentUser: UserData?
    
//    var username = CustomLabel(font: Font.font3)
//    var email = CustomLabel(font: Font.font3)
    
    var username: UILabel = {
        
        let label = UILabel()
        label.font = UIFont(name: "PTSans-Regular", size: 17)
        label.textColor = UIColor(red: 0.576, green: 0.612, blue: 0.631, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    var email: UILabel = {
        
        let label = UILabel()
        label.font = UIFont(name: "PTSans-Regular", size: 17)
        label.textColor = UIColor(red: 0.576, green: 0.612, blue: 0.631, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1).cgColor
        tableView.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
        configure()
        configureNavigationBar()
        fetchuser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.tableHeaderView = createTableHeader()
        configure()
        fetchuser()
    }
    
    //MARK: Helpers
    
    func configure() {
        
        view.addSubview(username)
        view.addSubview(email)
        
        username.translatesAutoresizingMaskIntoConstraints = false
        email.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
        
            username.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 10),
            username.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 90),
            username.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -90),
            
            email.topAnchor.constraint(equalTo: username.bottomAnchor, constant: 5),
            email.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80),
           email.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80),
        ])
        
    }
    
    func createTableHeader() -> UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
//        headerView.backgroundColor = .green
        
        imageView = UIImageView(frame: CGRect(x: (headerView.frame.width-150)/2, y: 50, width: 150, height: 150))
        imageView.contentMode = .scaleAspectFit
//        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor(red: 0.137, green: 0.176, blue: 0.212, alpha: 1).cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.image = UIImage(systemName: "person.fill")
        imageView.tintColor = UIColor(red: 0.616, green: 0.647, blue: 0.675, alpha: 1)
        imageView.backgroundColor = UIColor(red: 0.137, green: 0.176, blue: 0.212, alpha: 1)
        imageView.layer.masksToBounds = true
        headerView.addSubview(imageView)
        
        return headerView
    }
    
    func configureNavigationBar() {
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor(red: 0.616, green: 0.647, blue: 0.675, alpha: 1)]
        appearance.backgroundColor = UIColor(red: 0.137, green: 0.176, blue: 0.212, alpha: 1)
        navigationItem.title = "Profile"
//        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
    }
    
    func fetchuser(){
        
        let uid = Auth.auth().currentUser?.uid
        DatabaseManager.shared.fetchUser(uid: uid!){ user in
            self.username.text = "Username:\(user.username)"
            self.email.text = "Email:\(user.email)"
            
            self.currentUser = user
            
            print( "Profile/\(uid)")
            StorageManager.shared.downloadImageWithPath(path: "Profile/\(uid!)") { image in
                DispatchQueue.main.async {
                    self.imageView.image = image
                    
                }
            }
        }
    }
    
    func downloadImage(imageView: UIImageView, url: URL) {
        URLSession.shared.dataTask(with: url, completionHandler: { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                let image = UIImage(data: data)
                imageView.image = image
            }
        }).resume()
    }
}

//MARK: UITableViewDelegate, UITableViewDataSource

extension ProfileViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = content[indexPath.row]
        cell.textLabel?.textColor = .white
        cell.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        do {
            let isLoggedOut = DatabaseManager.shared.onLogout()
            if isLoggedOut {
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                nav.modalPresentationStyle = .fullScreen
                present(nav, animated: true, completion: nil)
            }
            
        }
        
    }
}

