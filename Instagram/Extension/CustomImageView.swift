//
//  CustomImageView.swift
//  Instagram
//
//  Created by prog on 4/27/19.
//  Copyright © 2019 prog. All rights reserved.
//

import Foundation
import UIKit

var cachedImage = [String:UIImage]()

class customImageView:UIImageView{
    
    var lastUsedUrl:String?
    func loadImageURL(urlString:String){
        lastUsedUrl = urlString
        //if image already exists in array use that otherwise fetch from firebase
        if let cachedImage = cachedImage[urlString]{
            self.image = cachedImage
            return
        }
        guard let url = URL(string: urlString) else{return}
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            if let err = err {
                print("Failed to fetch post image:", err)
                return
            }
            // asynchronous hence we check to see if its the correct url then load it otherwise dont load so images load only once and are not repeated
            if url.absoluteString != self.lastUsedUrl{
                return
            }
            guard let imageData =  data else{return}
            // afger fetching image set it to image cache 
            let photoImageView = UIImage(data: imageData)
            cachedImage[url.absoluteString] = photoImageView
            
            DispatchQueue.main.async {
                self.image = photoImageView
            }
            
        }.resume()
    }
}
