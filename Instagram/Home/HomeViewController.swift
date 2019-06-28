//
//  HomeViewController.swift
//  Instagram
//
//  Created by prog on 4/17/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout{

    private let cellIdentifier = "cell"
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        // Do any additional setup after loading the view.
        collectionView.register(HomeCell.self, forCellWithReuseIdentifier: cellIdentifier)
       
        setUpNavigationPicLogo()
        fetchPosts()
    }
    
    func setUpNavigationPicLogo(){
        navigationItem.titleView = UIImageView(image:#imageLiteral(resourceName: "logo2"))
    }
    //fetch the uid of the user who made the post ! for now the current user is the one who made the post
    
    
    
////    var user: User?
//    fileprivate func fetchUser() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//
//        Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
////            print(snapshot.value ?? "")
//
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//
//            self.user = User(uid: uid, dictionary: dictionary)
//
//
//        }) { (err) in
//            print("Failed to fetch user:", err)
//        }
//    }
    
    // we use observe single event so posts doenst update realtime
    
    
    fileprivate func fetchPostWithUserId(user:User){
        let ref = Database.database().reference().child("Posts").child(user.uid)
        ref.observeSingleEvent(of: .value) { (snapshot) in
            
            guard let dict = snapshot.value as? [String:Any] else {
                return
            }
            
            dict.forEach({ (key, value) in
                guard  let dict = value as? [String:Any] else {return}
                let post = Post(user: user , dictionary: dict)
                self.posts.append(post)
                
                
            })
            self.collectionView.reloadData()
            
            //            let post = post(dict)
            
            
            
            
        }
        
        
        
    }
    
    fileprivate func fetchPosts(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithID(uid: uid) { (user) in
            self.fetchPostWithUserId(user: user)
        }
       
        }
        
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! HomeCell
        cell.post = posts[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height:CGFloat = 40+8+8 //height of profileImageView+postiMAGEview
        height+=view.frame.width
        
        
        height+=50
        height+=60
        return .init(width: view.frame.width, height: height)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 0
//    }
    
    

   

}
