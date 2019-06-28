//
//  FirebaseUTil.swift
//  Instagram
//
//  Created by prog on 5/7/19.
//  Copyright © 2019 prog. All rights reserved.
//

import Foundation
import Firebase
extension Database {
    static func fetchUserWithID(uid:String,completion:@escaping (User)->()){
        Database.database().reference().child("Users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            
//            print("snapshot of users are ")
//            print(snapshot.value)
            guard let userDictionary = snapshot.value as? [String:Any] else{return}
            let user = User(uid: uid, dictionary: userDictionary)
            
            completion(user)
//            print("snapshot")
        }
    }
}
