//
//  User.swift
//  Instagram
//
//  Created by prog on 4/21/19.
//  Copyright © 2019 prog. All rights reserved.
//

import Foundation
struct User {
    let username :String
    let userProfileImageUrl:String
    let uid:String
    
    init(uid:String,dictionary : [String:Any]){
        self.username = dictionary["username"] as? String ?? ""
        self.userProfileImageUrl = dictionary["profilePicture"] as? String ?? ""
        self.uid = uid
        
    }
}
