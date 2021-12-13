//
//  RegistrationViewController.swift
//  CustomView
//
//  Created by Kshama Vidyananda on 10/11/21.
//

import UIKit
import FirebaseAuth

class RegistrationViewController: UIViewController {
    
    //MARK: Properties
    
    var delegate : UserAuthenticatedDelegate?
    let photButton : UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.tintColor = UIColor(red: 0.655, green: 0.675, blue: 0.69, alpha: 1)
        imageView.clipsToBounds = true
        imageView.image = SystemImage.personImage
        imageView.layer.cornerRadius = 40
        imageView.backgroundColor = UIColor(red: 0.176, green: 0.22, blue: 0.243, alpha: 1)
        
        return imageView
    }()
    
    var firstNameTextField = CustomTextField(placeholder: Placeholder.firstName)
    var lastNameTextField = CustomTextField(placeholder: Placeholder.lastName)
    var emailTextField = CustomTextField(placeholder: Placeholder.email)
    var passwordTextField = CustomTextField(placeholder: Placeholder.password)
    var signUpButton1 = ButtonSetTitle.signUp
    var backToLogin = ButtonSetTitle.backToLogin
    let scrollView = UIScrollView()
    
    lazy var firstNameContainer: InputContainerView = {
        firstNameTextField.keyboardType = .default
        firstNameTextField.textColor = UIColor(red: 0.655, green: 0.675, blue: 0.69, alpha: 1)
        firstNameTextField.attributedPlaceholder = NSAttributedString(string: Placeholder.firstName, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.655, green: 0.675, blue: 0.69, alpha: 1)])
        return InputContainerView(image: SystemImage.personImage!, textField: firstNameTextField, backgroundColor: UIColor(red: 0.176, green: 0.22, blue: 0.243, alpha: 1))
        
    }()
    
    lazy var lastNameContainer: InputContainerView = {
        lastNameTextField.keyboardType = .default
        lastNameTextField.textColor = UIColor(red: 0.655, green: 0.675, blue: 0.69, alpha: 1)
        lastNameTextField.attributedPlaceholder = NSAttributedString(string: Placeholder.lastName, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.655, green: 0.675, blue: 0.69, alpha: 1)])
        return InputContainerView(image: SystemImage.personImage!, textField: lastNameTextField, backgroundColor: UIColor(red: 0.176, green: 0.22, blue: 0.243, alpha: 1))
    }()
    
    lazy var emailContainer: InputContainerView = {
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.textColor = UIColor(red: 0.655, green: 0.675, blue: 0.69, alpha: 1)
        emailTextField.attributedPlaceholder = NSAttributedString(string: Placeholder.email, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.655, green: 0.675, blue: 0.69, alpha: 1)])
        return InputContainerView(image: SystemImage.email!, textField: emailTextField, backgroundColor: UIColor(red: 0.176, green: 0.22, blue: 0.243, alpha: 1))
        
    }()
    
    lazy var passwordContainer: InputContainerView = {
        passwordTextField.isSecureTextEntry = true
        passwordTextField.textColor = UIColor(red: 0.655, green: 0.675, blue: 0.69, alpha: 1)
        passwordTextField.attributedPlaceholder = NSAttributedString(string: Placeholder.password, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 0.655, green: 0.675, blue: 0.69, alpha: 1)])
        return InputContainerView(image: SystemImage.password!, textField: passwordTextField, backgroundColor: UIColor(red: 0.176, green: 0.22, blue: 0.243, alpha: 1))
    }()
    
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0.063, green: 0.114, blue: 0.145, alpha: 1)
        configure()
                configureNotificationObserver()
        //        createDismissKeyboardTapGesture()
        photButton.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        photButton.addGestureRecognizer(gesture)
        
    }
    
    //MARK: Actions
    
    @objc func didTapChangeProfilePic() {
        
        presentPhotoActionSheet()
    }
    
    @objc func handleSignUp(sender: UIButton){
        
        let error = validateFields()
        
        if error != nil {
            showAlert(title: "Error", message: error!)
            return
        }
        else {
            
            guard let firstName = firstNameTextField.text,
                  let lastName = lastNameTextField.text,
                  let email = emailTextField.text,
                  let profilePic = photButton.image,
                  let password = passwordTextField.text, !firstName.isEmpty,!lastName.isEmpty, !email.isEmpty, !password.isEmpty else {
                      self.showAlert(title: "Error", message: "Enter all the fields")
                      return
                  }
            DatabaseManager.shared.userExists(with: email) { exists in
                
                guard !exists else {
                    self.showAlert(title: "Exists", message: "Account for the email address already exists")
                    return
                }
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) {  [weak self] authResult, error in
                
                guard let self = self else {return}
                
                if error != nil {
                    self.showAlert(title: "Error", message: error!.localizedDescription)
                    return
                }
                if let authResult = authResult{
                    let uid = authResult.user.uid
                    
                    StorageManager.ImageUploader.uploadImage(image: profilePic, uid: uid) { url in
                        
                        let newuser = UserData(username: firstName + lastName, email: email, profileURL: url, uid: uid)
                        DatabaseManager.shared.addUser(user: newuser)
                        self.delegate?.UserAuthenticated()
                        self.dismiss(animated: true, completion: nil)
                    }
                    self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
                }
            }
        }
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
    
    @objc func scrollingTheView() {
        
        scrollView.contentSize = CGSize(width: view.frame.width, height: 600)
    }
    
    @objc func handlebackToLogin(){
        
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Helpers
    
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
    
    func configure() {
        
        signUpButton1.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        backToLogin.addTarget(self, action: #selector(handlebackToLogin), for: .touchUpInside)
//        view.addSubview(photButton)
        
        let stack = UIStackView(arrangedSubviews: [firstNameContainer,lastNameContainer,emailContainer,passwordContainer,signUpButton1])
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        photButton.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        
//        view.addSubview(stack)
        view.addSubview(scrollView)
        scrollView.addSubview(photButton)
        scrollView.addSubview(stack)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        photButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        photButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 40).isActive = true
        photButton.heightAnchor.constraint(equalToConstant: 120).isActive = true
        photButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        stack.topAnchor.constraint(equalTo: photButton.bottomAnchor, constant: 80).isActive = true
        stack.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        stack .widthAnchor.constraint(equalToConstant: 350).isActive = true
        scrollView.contentSize = CGSize(width: view.frame.width, height: 600)
    
    }
    
    func presentPhotoPicker() {
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
    func presentPhotoActionSheet() {
        
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How will you select a picture", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
            
        }))
        
        present(actionSheet,animated: true)
        
    }
}

//MARK: UIImagePickerControllerDelegate, UINavigationControllerDelegate

extension RegistrationViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard  let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.photButton.image = selectedImage
        return
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        return
    }
}
