//
//  ViewController.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 10/11/21.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //MARK: Properties
    
    let label : UILabel = {
        
       let label = UILabel()
        
        label.text = "Chat App"
        label.textColor = .white
//        label.font = label.font.withSize(20)
        label.font = UIFont.boldSystemFont(ofSize: 40.0)
       label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    
    var emailTextField = CustomTextField(placeholder: "  Email")
    var passwordTextField = CustomTextField(placeholder: "  Password")
    var signUpButton1 = CustomButton(setTitle: "Sign Up")
    var loginButton1 = CustomButton(setTitle: "Login")
    
    lazy var emailContainerView : InputContainerView = {
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        return InputContainerView(image: UIImage(systemName: "envelope")!, textField: emailTextField)
        
    }()
    
    lazy var passwordContainerView : InputContainerView = {
        passwordTextField.isSecureTextEntry = true
        return InputContainerView(image: UIImage(systemName: "lock")!, textField: passwordTextField)
  
    }()
    
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        
        navigationItem.title = "Login"
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
//        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)]
        configure()
        //        createDismissKeyboardTapGesture()
        //        configureNotificationObserver()
        
    }
    
    //MARK: Helpers
    
    func configure() {
        
        loginButton1.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        signUpButton1.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        let stack = UIStackView(arrangedSubviews: [label, emailContainerView, passwordContainerView, loginButton1, signUpButton1])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        view.addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -20).isActive = true
        
    }
    
    
    func createDismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func configureNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    //MARK: Actions
    
    @objc func keyboardWillShow(){
        print("Keybaord will show")
        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 70
        }
    }
    
    @objc func keyboardWillHide(){
        print("Keybaord will hide")
        if view.frame.origin.y == -70 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func handleLogin() {
        
        guard let email = emailTextField.text, let password = passwordTextField.text, !email.isEmpty, !password.isEmpty else {
            showAlert(title: "Error", message: "Please enter all the fields to login")
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else {
                return
            }
            let user = result.user
            UserDefaults.standard.set(email, forKey: "email")
            strongSelf.navigationController?.dismiss(animated: true, completion: nil)
            
        })
    }
    
    @objc func didTapRegister() {
        
        let vc = RegistrationViewController()
        vc.title = "Create Account"
        //        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
