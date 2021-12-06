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
    
    var delegate : UserAuthenticatedDelegate?
    let label : UILabel = {
        
        let label = UILabel()
        
        label.text = "Chat App"
        label.textColor = .link
        label.font = UIFont.boldSystemFont(ofSize: 40.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var emailTextField = CustomTextField(placeholder: Placeholder.email)
    var passwordTextField = CustomTextField(placeholder: Placeholder.password)
    var signUpButton1 = ButtonSetTitle.signUp
    var loginButton1 = ButtonSetTitle.login
    var forgotPasswordButton = ButtonSetTitle.forgotPassword
    let scrollView = UIScrollView()
    
    lazy var emailContainerView : InputContainerView = {
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none

        return InputContainerView(image: SystemImage.email!, textField: emailTextField)
        
    }()
    
    lazy var passwordContainerView : InputContainerView = {
        passwordTextField.isSecureTextEntry = true

        return InputContainerView(image: SystemImage.password!, textField: passwordTextField)
        
    }()
        
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
//        navigationItem.title = "Login"
//        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        configure()
        //        createDismissKeyboardTapGesture()
                configureNotificationObserver()
        
    }
    
    //MARK: Helpers
    
    func configure() {
        
        loginButton1.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        signUpButton1.addTarget(self, action: #selector(didTapRegister), for: .touchUpInside)
        forgotPasswordButton.addTarget(self, action: #selector(handleForgotPassword), for: .touchUpInside)
        let stack = UIStackView(arrangedSubviews: [label, emailContainerView, passwordContainerView, loginButton1, signUpButton1, forgotPasswordButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
//        scrollView.backgroundColor = .red
//        stack.backgroundColor = .black
        stack.distribution = .fill

//        view.addSubview(stack)
        view.addSubview(scrollView)
        scrollView.addSubview(stack)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 150).isActive = true
//        stack.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
//        stack.rightAnchor.constraint(equalTo: scrollView.rightAnchor,constant: -20).isActive = true
        stack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stack .widthAnchor.constraint(equalToConstant: 350).isActive = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: 500)
    }
    
    func createDismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func configureNotificationObserver(){
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollingTheView), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func validateFields() -> String? {
        
        if Validation.isEmailValid(emailTextField.text!) == false {
            return "Please enter proper email"
        }
        if Validation.isPasswordValid(passwordTextField.text!) == false {
            return "Please enter proper password"
        }
        return nil
    }
    
    //MARK: Actions
    
    @objc func scrollingTheView() {
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: 500)
    }
    
    @objc func keyboardWillShow(){

        if view.frame.origin.y == 0 {
            self.view.frame.origin.y -= 70
        }
    }
    
    @objc func keyboardWillHide(){
        
        if view.frame.origin.y == -70 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func handleLogin() {
        
        let error = validateFields()
        if error != nil {
            showAlert(title: "Error", message: error!)
            return
        }else {
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
                self!.delegate?.UserAuthenticated()
                self!.dismiss(animated: true, completion: nil)
                
            })
        }
    }
    
    @objc func didTapRegister() {
        
        let vc = RegistrationViewController()
        vc.delegate = delegate
        vc.title = "Create Account"
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
        
    }
    
    @objc func handleForgotPassword() {
        
        let resetVC = ForgotPasswordViewController()
        resetVC.modalPresentationStyle = .fullScreen
        present(resetVC, animated: true, completion: nil)
    }
}
