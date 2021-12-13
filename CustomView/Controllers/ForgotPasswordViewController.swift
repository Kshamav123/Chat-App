//
//  ForgotPasswordViewController.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 04/12/21.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
        configure()
        configureNotificationObserver()
    }
    
    let label : UILabel = {
        
        let label = UILabel()
        
        label.text = "Reset Password"
        label.textColor = UIColor(red: 0.02, green: 0.275, blue: 0.251, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 40.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    var resetPasswordButton = ButtonSetTitle.resetPassword
    var backToLoginButton = ButtonSetTitle.backToLogin
    var emailTextField = CustomTextField(placeholder: "")
    let scrollView = UIScrollView()
    
    lazy var emailContainerView : InputContainerView = {
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.textColor = UIColor(red: 0.655, green: 0.675, blue: 0.69, alpha: 1)
        emailTextField.attributedPlaceholder = NSAttributedString(string: Placeholder.email, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.655, green: 0.675, blue: 0.69, alpha: 1)])
        return InputContainerView(image: UIImage(systemName: "envelope")!, textField: emailTextField, backgroundColor: UIColor(red: 0.176, green: 0.22, blue: 0.243, alpha: 1))

}()
        
    func configure () {
        
        resetPasswordButton.addTarget(self, action: #selector(didTapResetPassword), for: .touchUpInside)
        backToLoginButton.addTarget(self, action: #selector(didTapBackToLogin), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [label, emailContainerView,resetPasswordButton, backToLoginButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 10
        stack.axis = .vertical

        view.addSubview(scrollView)
        scrollView.addSubview(stack)
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 150).isActive = true
        stack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stack .widthAnchor.constraint(equalToConstant: 350).isActive = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: 600)
    }
    
    
    @objc func didTapResetPassword(sender: UIButton) {
        
        sender.flash()
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) {
            error in
            
            if error != nil {

                self.dismiss(animated: true, completion: nil)
            }

            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func configureNotificationObserver(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollingTheView), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
   
    
    @objc func didTapBackToLogin(sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func scrollingTheView() {
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: 600)
    }
    
}
