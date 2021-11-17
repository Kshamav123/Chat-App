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
    
    let photButton : UIImageView = {
        
        let imageView = UIImageView()
        
        imageView.tintColor = .white
        imageView.clipsToBounds = true
        imageView.image = UIImage(systemName: "person.fill")
        imageView.layer.cornerRadius = 40
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .darkGray
        
        return imageView
    }()
    
    var firstNameTextField = CustomTextField(placeholder: "  First Name")
    var lastNameTextField = CustomTextField(placeholder: "  Last Name")
    var emailTextField = CustomTextField(placeholder: "  Email")
    var passwordTextField = CustomTextField(placeholder: "  Password")
    var signUpButton1 = CustomButton(setTitle: "Sign Up")
    
    lazy var firstNameContainer: InputContainerView = {
        firstNameTextField.keyboardType = .default
        return InputContainerView(image: UIImage(systemName: "person.fill")!, textField: firstNameTextField)
        
    }()
    
    lazy var lastNameContainer: InputContainerView = {
        lastNameTextField.keyboardType = .default
        return InputContainerView(image: UIImage(systemName: "person.fill")!, textField: lastNameTextField)
    }()
    
    lazy var emailContainer: InputContainerView = {
        emailTextField.keyboardType = .emailAddress
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        return InputContainerView(image: UIImage(systemName: "envelope")!, textField: emailTextField)
        
    }()
    
    lazy var passwordContainer: InputContainerView = {
        passwordTextField.isSecureTextEntry = true
        return InputContainerView(image: UIImage(systemName: "lock")!, textField: passwordTextField)
    }()
    
    
    //MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        configure()
        //        configureNotificationObserver()
        //        createDismissKeyboardTapGesture()
        photButton.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeProfilePic))
        photButton.addGestureRecognizer(gesture)
        
    }
    
    //MARK: Actions
    
    @objc func didTapChangeProfilePic() {
        
        presentPhotoActionSheet()
    }
    
    @objc func handleSignUp(){
        
        guard let firstName = firstNameTextField.text,
              let lastName = lastNameTextField.text,
              let email = emailTextField.text,
              let password = passwordTextField.text,!firstName.isEmpty,!lastName.isEmpty, !email.isEmpty, !password.isEmpty else {
                  showAlert(title: "Error", message: "Enter all the fields")
                  return
              }
        DatabaseManager.shared.userExists(with: email, completion: { [weak self] exists in
            
            guard let strongSelf = self else {
                return
            }
            guard !exists else {
                strongSelf.showAlert(title: "Exists", message: "Account for the email address already exists")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: {  authResult, error in
                
                guard authResult != nil, error == nil else {
                    return
                }
                let chatUser = ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email)
                DatabaseManager.shared.insertUser(with: chatUser, completion: { success in
                    if success{
                        //upload image
                        guard let image = strongSelf.photButton.image, let data = image.pngData() else {
                            return
                        }
                        let filename = chatUser.profilePictureFileName
                        StorageManager.shared.uploadProfilePicture(with: data ,fileName: filename, completion: {result in
                            switch result {
                                
                            case .success(let downloadUrl):
                                UserDefaults.standard.set(downloadUrl, forKey: "profile_picture_url")
                                print(downloadUrl)
                            case .failure(let error):
                                print("Storage manager error:\(error)")
                            }
                        })
                    }
                })
                
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
                
            })
            
        })
        
    }
    
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
    
    //MARK: Helpers
    
    func createDismissKeyboardTapGesture(){
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    func configureNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    
    //
    //    func alertUserLoginError(message: String = "please enter all information to create a new account") {
    //
    //        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
    //        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
    //        present(alert, animated: true)
    //
    //    }
    
    func configure() {
        
        signUpButton1.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        view.addSubview(photButton)
        photButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        photButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        photButton.heightAnchor.constraint(equalToConstant: 120).isActive = true
        photButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [firstNameContainer,lastNameContainer,emailContainer,passwordContainer,signUpButton1])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        view.addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: photButton.bottomAnchor, constant: 80).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -20).isActive = true
        
    }
}

//MARK: Extensions

extension RegistrationViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How will you select a picture", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
            
        }))
        
        present(actionSheet,animated: true)
        
    }
    
    func presentPhotoPicker() {
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    
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
