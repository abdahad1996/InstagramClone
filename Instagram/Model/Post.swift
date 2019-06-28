//
//  Post.swift
//  Instagram
//
//  Created by prog on 4/27/19.
//  Copyright © 2019 prog. All rights reserved.
//

import Foundation
import UIKit

struct Post {
    let user:User
    let caption :String
    let postImageUrl:String
    
    init(user:User,dictionary:[String:Any]) {
        caption = dictionary["caption"] as? String ?? ""
        postImageUrl = dictionary["postimageUrl"] as? String ?? ""
        self.user = user
    }
}
