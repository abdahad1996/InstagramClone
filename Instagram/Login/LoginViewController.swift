//
//  LoginViewController.swift
//  Instagram
//
//  Created by prog on 4/15/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    let LogocontainerView : UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)

        let LogoImageView = UIImageView(image: #imageLiteral(resourceName: "Instagram_logo_white") )
        LogoImageView.contentMode = .scaleAspectFill
//        LogoImageView.clipsToBounds = true
        
        
        view.addSubview(LogoImageView)
        LogoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        LogoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        LogoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
             view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)

        
        
        return view
        
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
        button.setTitle("Login", for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        
        return button
    }()
    let dontHaveAccount :UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor :UIColor.lightGray])
        
        attributedTitle.append(NSMutableAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font  : UIFont.boldSystemFont(ofSize: 14),
            NSAttributedString.Key.foregroundColor:UIColor.rgb(red: 17, green: 154, blue: 207)]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(LogocontainerView)
        
        LogocontainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        tabBarController?.tabBar.isHidden = true
        
      
        
        setUpInputField()

        view.addSubview(dontHaveAccount)
        dontHaveAccount.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 50)
   
        // Do any additional setup after loading the view.
    }
//
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setUpInputField(){
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,button])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.anchor(top: LogocontainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 40, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 140)
        
    }
    
    @objc func handleLogin(){
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, err) in
            
            if let err = err {
                print("Failed to sign in with email:", err)
                return
            }
            
            print("Successfully logged back in with user:", user?.user.uid ?? "")
            
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarViewController else { return }
            
            mainTabBarController.setUpViewController()
            
            self.dismiss(animated: true, completion: nil)
            
        })
    }
    @objc func handleSignUp(){
        print("hello")
        let signUpViewController = SignUpViewController()
        navigationController?.pushViewController(signUpViewController, animated: true)
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
}
