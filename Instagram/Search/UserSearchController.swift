//
//  UserSearchController.swift
//  Instagram
//
//  Created by prog on 5/11/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class UserSearchController: UICollectionViewController,UICollectionViewDelegateFlowLayout,UISearchBarDelegate{
    // lazy so we can use self ! after usersearchcontroller is instatntiated den only   lazy is instantiated
   lazy var searchBar : UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter Username "
        searchBar.tintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        searchBar.delegate = self
        return searchBar
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        collectionView.backgroundColor = .white
        navigationController?.navigationBar.addSubview(searchBar)
        let navbar = navigationController?.navigationBar
        
        searchBar.anchor(top: navbar?.topAnchor ,left: navbar?.leftAnchor, bottom: navbar?.bottomAnchor, right: navbar?.rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        // Register cell classes
        self.collectionView!.register(UserSearchCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .onDrag
        
        fetchUsers()
        

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        searchBar.isHidden = false
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //if no search show whole list
        if searchText.isEmpty {
            filteredUsers = users
        }
        //filter based on character if its present in username
        else{
        filteredUsers = users.filter { (User) -> Bool in
            return User.username.lowercased().contains(searchText.lowercased())
        }
        }
        self.collectionView.reloadData()
    }
    var filteredUsers = [User]()
    var users = [User]()
    func fetchUsers(){
        Database.database().reference().child("Users").observeSingleEvent(of: .value) { (snapshot) in
            guard let dictrionaries = snapshot.value as? [String:Any] else {return}
            dictrionaries.forEach({ (key: String, value: Any) in
                print(key,value)

                //post by yourslef should not be shown
                if key == Auth.auth().currentUser?.uid {
                    return
                }
                
                guard let userDic = value as? [String:Any] else {return}
                 let user = User(uid: key, dictionary: userDic)
                self.users.append(user)
                
            })
            
            self.users.sort(by: { (u1, u2) -> Bool in
                return u1.username.compare(u2.username) == .orderedAscending
            })
            self.filteredUsers = self.users
            self.collectionView.reloadData()
        }
    }

    // MARK: UICollectionViewDataSource



    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return filteredUsers.count    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.item]
    
        // Configure the cell
    
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.size.width, height: 66)
    }
    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        
        
        let user = filteredUsers[indexPath.item]
        let userProfileController = UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout())
        navigationController?.pushViewController(userProfileController, animated: true)
        userProfileController.userId = user.uid

    }
}
