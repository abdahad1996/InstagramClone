//
//  SharePhotoController.swift
//  Instagram
//
//  Created by prog on 4/21/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase



class SharePhotoController: UIViewController {

    override var prefersStatusBarHidden: Bool{
        return true
    }
    var selectedImage:UIImage? {
        didSet{
            imageView.image = selectedImage
        }
    }
    let imageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .red
        return imageView
        
    }()
    let textView:UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.text = "hello"
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        // Do any additional setup after loading the view.
        
       setUpImageAndTextField()
    }
    
    func setUpImageAndTextField(){
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        
        containerView.addSubview(imageView)
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 84, height: 84)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
        
      @objc func handleShare(){
        print("share")
        //save image to firestorage and save the url and caption to database as post
        guard let caption = textView.text , caption.count > 0 else {return}
        guard let image = selectedImage else {return}
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false

        guard let upLoadImage = image.jpegData(compressionQuality: 0.5) else{return}
        
        let filename = NSUUID().uuidString
        
        Storage.storage().reference().child("Post").child(filename).putData(upLoadImage, metadata: nil, completion: { (metaData, err) in
            if let error = err {
                print("error in putting it in firebase storage \(error.localizedDescription)")
                self.navigationItem.rightBarButtonItem?.isEnabled = true

            }
            
            let photoRef =  Storage.storage().reference().child("Post").child(filename)
            photoRef.downloadURL(completion: { (url, err) in
                if let error = err {
                    print("error is \(String(describing: error.localizedDescription))")
                    self.navigationItem.rightBarButtonItem?.isEnabled = true

                    
                }
                guard let url = url?.absoluteString else {return
                    
                }
                print("succesfully added photo to storage \(url)")
                self.saveToDatabaseWithImageUrl(imageUrl: url)
                
                
            })
            
            
        })
        
        
        
    }
    

    fileprivate func saveToDatabaseWithImageUrl(imageUrl:String){
        guard let caption = textView.text , caption.count > 0 else {return}
        guard let image = selectedImage else {return}
        guard let uid = Auth.auth().currentUser?.uid else{return}
        // this refers to posts tree with uid of a user and unique id of a particular  post
        
        // we added creation date so we could order them
        let postRef = Database.database().reference().child("Posts").child(uid).childByAutoId()
        let values = ["postimageUrl":imageUrl,"caption":caption,"ImageWidth":image.size.width,"ImageHeight":image.size.height,"creationDate":Date().timeIntervalSince1970] as [String:Any]
        postRef.updateChildValues(values) { (err, ref) in
            if let error = err {
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("error is \(error.localizedDescription)")
            }
            print("saved to database successfully ")
            self.dismiss(animated: true, completion: nil )
            
        }
        
        
        
//        let userPhotoRef =
        
        
        
    }

}
