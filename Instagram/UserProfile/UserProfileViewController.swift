//
//  UserProfileViewController.swift
//  Instagram
//
//  Created by prog on 4/19/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
import Firebase

private let cellIdentifier = "Cell"
private let headerIdentifier = "Header"



class UserProfileViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {

    var posts = [Post]()
    var userId:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white

      
        // Register cell classes
        self.collectionView.register(UserProfileHeaderCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        self.collectionView!.register(UserProfileCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        

//        fetchPosts()
        setUpLogOut()
        fetchUser()
//fetchOrderedPosts()        // Do any additional setup after loading the view.
        
    }

   fileprivate func setUpLogOut(){
    navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "gear").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action:#selector(handleLogOut))
    
    }
    
    @objc func handleLogOut(){
        let alertController = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "logOut", style: .destructive, handler: { (_) in
            print("logout")
            do {
                try  Auth.auth().signOut()
                let loginController = LoginViewController()
                let navigationController = UINavigationController(rootViewController: loginController)
                self.present(navigationController, animated: true, completion: nil)
            }
            catch let  err {
                print("the error \(err.localizedDescription)")
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }

    var user: User?
    //fetch user with uid ! either fetch current user or fetch user searched from searchcontroller
    fileprivate func fetchUser() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "")
//
//        Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
//            print(snapshot.value ?? "")
//
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//
        Database.fetchUserWithID(uid: uid) { (User) in
            self.user = User
            self.navigationItem.title = self.user?.username
            
            self.collectionView?.reloadData()
            self.fetchOrderedPosts()
        }
            
    }
    //observe gets called immediately when a new child is added
    fileprivate func fetchOrderedPosts(){
//        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let uid = user?.uid else{return}
        
        let ref = Database.database().reference().child("Posts").child(uid)
        
        ref.queryOrdered(byChild: "creationDate").observe(.childAdded) { (snapshot) in
            guard let dic = snapshot.value as? [String:Any] else{return}
            let post = Post(user: self.user!, dictionary: dic)
            self.posts.insert(post, at: 0)
//            self.posts.append(post)
            self.collectionView.reloadData()
        }

    
    }
//
//    fileprivate func fetchPosts(){
//
//        guard let uid = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let ref = Database.database().reference().child("Posts").child(uid)
//        ref.observeSingleEvent(of: .value) { (snapshot) in
//
//            print(snapshot.value ?? "")
//
//            guard let dict = snapshot.value as? [String:Any] else {
//                return
//            }
//
//            dict.forEach({ (key, value) in
//                guard  let dict = value as? [String:Any] else {return}
//                let post = Post(user: self.user!, dictionary: dict)
//                self.posts.append(post)
//                self.collectionView.reloadData()
//
//
//            })
//            self.collectionView.reloadData()
//
////            let post = post(dict)
//
//
//
//
//
//        }
//    }
//    // MARK: UICollectionViewDataSource

   

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
//        return posts.count
        return posts.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! UserProfileCollectionViewCell
        cell.post = posts[indexPath.item]
//        cell.backgroundColor = .red
        // Configure the cell
    
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as? UserProfileHeaderCell else {
            return UICollectionReusableView()
        }
        header.user = user
     
        
        header.backgroundColor = .white 
        return header
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.size.width, height: 200)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.size.width-2)/3
        return .init(width: width, height: width)
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
