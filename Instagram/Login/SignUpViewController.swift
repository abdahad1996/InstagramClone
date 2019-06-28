//
//  SignUpViewController.swift
//  Instagram
//
//  Created by prog on 4/15/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SignUpViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var photoRef :StorageReference?
    
    //MARK:- PHOTOREGISTERATION METHODS AND UI
    let plusPhotoButton : UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "plus_photo").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handlePlusPhoto(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    var signUpImage:UIImage?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            plusPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
            signUpImage = image
            
        }
        else if let editedImage = info[.editedImage] as? UIImage {
            plusPhotoButton.setImage(editedImage.withRenderingMode(.alwaysOriginal), for: .normal)
            signUpImage = editedImage
        }
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width/2
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 3
        plusPhotoButton.layer.masksToBounds = true 
        
        
        dismiss(animated: true, completion: nil)
        
    }
    //Mark:textfield buttons and methods
    
    let UserNameTextField :UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Username"
        textField.font = UIFont.boldSystemFont(ofSize: 14)
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        
        textField.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
        
        return textField
    }()
    
    
    
    let emailTextField :UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Email"
        textField.font = UIFont.boldSystemFont(ofSize: 14)
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        
        textField.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
        
        return textField
    }()
    
    let passwordTextField :UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.placeholder = "Password"
        textField.font = UIFont.boldSystemFont(ofSize: 14)
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        
        textField.addTarget(self, action: #selector(handleTextInputChanged), for: .editingChanged)
        
        
        return textField
    }()
    let button:UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.layer.cornerRadius = 10
        button.setTitle("Sign Up", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
    }()
    let alreadyHaveAccountButton :UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
                                                                                                         NSAttributedString.Key.foregroundColor :UIColor.lightGray])
        
        attributedTitle.append(NSMutableAttributedString(string: "Sign In", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 14),
                                                                                         NSAttributedString.Key.foregroundColor:UIColor.rgb(red: 17, green: 154, blue: 207)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()

    @objc func handleAlreadyHaveAccount() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc func handleTextInputChanged(){
        print("he")
        let formIsValid = emailTextField.text?.count ?? 0 > 0  &&  passwordTextField.text?.count ?? 0 > 0
        if formIsValid {
            button.isEnabled = true
            button.backgroundColor = UIColor.rgb(red: 17, green: 154, blue: 237)
        }
        else {
            button.isEnabled = false
            button.backgroundColor = UIColor.rgb(red: 149, green: 204, blue: 244)
        }
        
    }
    
    var profilePicUrl:StorageReference?

    @objc func handleSignUp(){
        guard let username = UserNameTextField.text, username.count>0 else{return}
        guard let email = emailTextField.text, email.count>0 else{return}
        guard let password = passwordTextField.text, password.count>0 else{return}
        
        
        Auth.auth().createUser(withEmail: email, password: password) { (User, err) in
            if let error = err {
                print(error.localizedDescription)
                
                return
            }
            
            
            guard let image = self.signUpImage else {
                print("error no image found")
                return
                
        }
            //convert image into data bytes
            guard let uploadData = image.jpegData(compressionQuality: 0.3) else {return}
            print(uploadData)
            
            let fileName = NSUUID().uuidString
            
            //store Imgdata in bytes in firebase storage
            Storage.storage().reference().child("Profile_images").child(fileName).putData(uploadData, metadata: nil, completion: { (metaData, err) in
                
                if let error = err {
                    print("error in putting it in firebase storage \(error.localizedDescription)")
                }
               
                
                guard let uID = User?.user.uid else {
                    print("no user ")
                    return
                }
                
                
                //                 writing userData to firebase database using photourl from storage
                
                
                let imageUrlref = Storage.storage().reference().child("Profile_images").child(fileName)
                self.profilePicUrl = imageUrlref
                print("photoref is \(String(describing: self.profilePicUrl))")
                
                guard let profilePicUrl = self.profilePicUrl else{return}
                
                profilePicUrl.downloadURL(completion: { (URL, Error) in
                    
                    if let err = Error {
                        print("the error is ")
                        
                        print(err.localizedDescription)
                        return
                        
                    }
                    
                    
                    if let url = URL{
                        
                        let UserDictionary = ["username":username,"profilePicture":url.absoluteString]
                        let UserUidDict = [uID:UserDictionary]
                        
                        
                        Database.database().reference().child("Users").updateChildValues(UserUidDict, withCompletionBlock: { (Error, DatabaseReference) in
                            if let err = Error {
                                print("the error is \(err.localizedDescription)")
                            }
                            print("successfully saved user into database")
                            
                            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarViewController else { return }
                            
                            mainTabBarController.setUpViewController()
                            
                            self.dismiss(animated: true, completion: nil)
                            
                        })
                        
                    }
                    
                    
                })
                //
                

            })
            
//
           
                    
               
                
                
//
            
            
            
        }
        print("sign in ")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil , right: nil, paddingTop: 40, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 140, height: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setupInputFields()
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 50)
        
        // Do any additional setup after loading the view.
    }
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, UserNameTextField, passwordTextField, button])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 200)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
