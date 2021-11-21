//
//  ProfileViewController.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 15/11/21.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    
    var imageView: UIImageView!
    
    let content = ["Logout"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = createTableHeader()
        fetchuser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.tableHeaderView = createTableHeader()
        fetchuser()
    }
    
    func createTableHeader() -> UIView? {
//        guard let email = UserDefaults.standard.value(forKey: "email") as? String  else {
//            return nil
//        }
//
//        let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
//        let filename = safeEmail + "_profile_picture.png"
//
//        let path = "images/"+filename
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 300))
        headerView.backgroundColor = .green
        
        imageView = UIImageView(frame: CGRect(x: (headerView.frame.width-150)/2, y: 75, width: 150, height: 150))
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.cornerRadius = imageView.frame.width/2
        imageView.layer.masksToBounds = true
        headerView.addSubview(imageView)
        
//        StorageManager.shared.downloadURL(for: path, completion: { [weak self] result in
//            switch result {
//            case .success(let url):
//                print("XXXXXXXXXXXXXXXXXXXXXXXx")
//                self?.downloadImage(imageView: imageView, url: url)
//            case .failure(let error):
//                print("failed to get download url: \(error)")
//            }
//
//        })
        
       return headerView
    }
    
    func fetchuser(){
        
        let uid = Auth.auth().currentUser?.uid
        print( "Profile/\(uid)")
        StorageManager.shared.downloadImageWithPath(path: "Profile/\(uid!)") { image in
            print("((((((((((((((((((((((((((")
            DispatchQueue.main.async {
                self.imageView.image = image
                
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

extension ProfileViewController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = content[indexPath.row]
//        cell.textLabel?.textAlignment = .center
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
    
