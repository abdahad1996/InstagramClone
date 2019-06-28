//
//  UserProfileCollectionViewCell.swift
//  Instagram
//
//  Created by prog on 4/27/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit

class UserProfileCollectionViewCell: UICollectionViewCell {
    
    var post:Post? {
        didSet{
            guard let imageURL = post?.postImageUrl else{return}
            photoImageView.loadImageURL(urlString: imageURL)
        }
    }
    
    let photoImageView : customImageView = {
        let imageView = customImageView()
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .blue
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "capture_photo")
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(photoImageView)
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
