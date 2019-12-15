//
//  SignUpVC.swift
//  InstagramClone
//
//  Created by Donald McAllister on 12/14/19.
//  Copyright © 2019 Donald McAllister. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class SignUpVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageSelected = false
    
    let plusPhotoBtn: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true 
        button.addTarget(self, action: #selector(handleSelectProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    let fullNameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Full name"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
         tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Username"
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
         tf.addTarget(self, action: #selector(formValidation), for: .editingChanged)
        return tf
    }()
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
        button.layer.cornerRadius = 5
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    
    let alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?   ", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)]))
         button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
       
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(plusPhotoBtn)
        plusPhotoBtn.anchor(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 40, left: 0, bottom: 0, right: 0), size: .init(width: 140, height: 140))
        plusPhotoBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        configureViewComponents()
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, size: .init(width: 0, height: 50))
        
        setupRegistrationViewModelObserver()

    }
    
    // MARK:- Private
    
    let registrationViewModel = RegistrationViewModel()
    
    fileprivate func setupRegistrationViewModelObserver() {
        //bindable
        registrationViewModel.bindableIsFormValid.bind { [unowned self] (isFormValid) in
            guard let isFormValid = isFormValid else { return }
             print("Form is changing, is it valid?", isFormValid)
                       
                       self.signUpButton.isEnabled = isFormValid
            //  if isFormValid && self.imageSelected == true {
                       if isFormValid == true {
                            self.signUpButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
                       } else {
                           self.signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
                       }
        }
        
        //old observer code:
//        registrationViewModel.isFormValidObserver = { [unowned self] (isFormValid) in
//            print("Form is changing, is it valid?", isFormValid)
//
//            self.signUpButton.isEnabled = isFormValid
//            if isFormValid && self.imageSelected == true {
//                 self.signUpButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
//            } else {
//                self.signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
//            }
//        }
        
        // viewModel tracks registration now.. and will bind like the observer code before
        registrationViewModel.bindableImage.bind { [unowned self] (profileImage) in
                self.plusPhotoBtn.setImage(profileImage?.withRenderingMode(.alwaysOriginal), for: .normal)
                    self.dismiss(animated: true, completion: nil)
        }
        // observer:
//        registrationViewModel.imageObserver = { [unowned self] profileImage in
//            self.plusPhotoBtn.setImage(profileImage?.withRenderingMode(.alwaysOriginal), for: .normal)
//            self.dismiss(animated: true, completion: nil)
//        }
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //selected image
        guard let profileImage = info[.editedImage] as? UIImage? else {
            imageSelected = false
            return
        }
        
        //set imageSelected to true:
        imageSelected = true
        registrationViewModel.bindableImage.value = profileImage //bindable
     //   registrationViewModel.image = profileImage //observer
        
        //configure plusPhotoBtn with selected image
        plusPhotoBtn.layer.cornerRadius = plusPhotoBtn.frame.width / 2
        plusPhotoBtn.layer.masksToBounds = true
        plusPhotoBtn.layer.borderColor = UIColor.black.cgColor
        plusPhotoBtn.layer.borderWidth = 2
        //move below to setupRegistrationViewModelObserver():
//        plusPhotoBtn.setImage(profileImage?.withRenderingMode(.alwaysOriginal), for: .normal)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSelectProfilePhoto() {
        //configure image picker
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        //present image picker
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    fileprivate func showHUDWithError(error: Error) {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Failed registration"
        hud.detailTextLabel.text = error.localizedDescription
        hud.show(in: self.view)
        hud.dismiss(afterDelay: 4)
    }
    
    @objc func handleSignUp() {
      //  self.handleTapDismiss() // TO DO
        //properties
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullNameTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
            //handle error
            if let error = error {
                print("Failed to create user with error: ", error.localizedDescription)
                self.showHUDWithError(error:error)
            }
            
            print("Successfully registered user:", authResult?.user.uid ?? "")
            
            //set profile image
            guard let profileImg = self.plusPhotoBtn.imageView?.image else { return }
            
            //upload data
            guard let uploadData = profileImg.jpegData(compressionQuality: 0.3) else { return }
            
            //place image in firebase storage
            let filename = NSUUID().uuidString
            
            // UPDATE: - In order to get download URL must add filename to storage ref like this
            let storageRef = Storage.storage().reference(withPath: "/images/\(filename)")
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                // handle error
                if let error = error {
                    print("Failed to upload image to Firebase Storage with error", error.localizedDescription)
                    return
                }
                
                // UPDATE: - Firebase 5 must now retrieve download url
                storageRef.downloadURL(completion: { (downloadURL, error) in
                    guard let profileImageUrl = downloadURL?.absoluteString else {
                        print("DEBUG: Profile image url is nil")
                        return
                    }
                    // user id
                    guard let uid = authResult?.user.uid else { return }
//                    guard let fcmToken = Messaging.messaging().fcmToken else { return }
                    
                    let dictionaryValues = ["name": fullname,
                                            "username": username,
                                            "profileImageUrl": profileImageUrl]
                    
                    let values = [uid: dictionaryValues]
                    
                    
                    //save user info to database
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, ref) in
                        
                        print("successfull created user and saved information.")
                    })
                })
            })
        }
    }
    
    @objc func formValidation(textField: UITextField) {
        if textField == emailTextField {
            registrationViewModel.email = textField.text
        } else if textField == fullNameTextField {
            registrationViewModel.fullName = textField.text
        } else if textField == usernameTextField {
            registrationViewModel.userName = textField.text
        } else {
            //password
            registrationViewModel.password = textField.text
        }
        
//        guard
//            emailTextField.hasText,
//            passwordTextField.hasText,
//            fullNameTextField.hasText,
//            usernameTextField.hasText,
//            imageSelected == true else {
//                signUpButton.isEnabled = false
//                signUpButton.backgroundColor = UIColor(red: 149/255, green: 204/255, blue: 244/255, alpha: 1)
//                return
//        }
//
//        signUpButton.isEnabled = true
//        signUpButton.backgroundColor = UIColor(red: 17/255, green: 154/255, blue: 237/255, alpha: 1)
    }
    
    
    func configureViewComponents() {
           let stackView = UIStackView(arrangedSubviews: [emailTextField, fullNameTextField, usernameTextField, passwordTextField, signUpButton])
           stackView.axis = .vertical
           stackView.spacing = 10
           stackView.distribution = .fillEqually
           view.addSubview(stackView)
           stackView.anchor(top: plusPhotoBtn.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 24, left: 20, bottom: 0, right: 20), size: .init(width: 0, height: 240))
       }
}

