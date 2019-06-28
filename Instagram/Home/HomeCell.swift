//
//  HomeCell.swift
//  Instagram
//
//  Created by prog on 4/28/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    
    var post:Post?{
        didSet{
            guard let ImageUrl = post?.postImageUrl else{return}
            postImageView.loadImageURL(urlString: ImageUrl)
            userNameLabel.text = "testing username"
            userNameLabel.text = post?.user.username
            
            guard let profileImageUrl = post?.user.userProfileImageUrl else {return}
            userProfileImageView.loadImageURL(urlString: profileImageUrl)
            attributedText()
        }
    }
    
    let userProfileImageView:customImageView = {
        let imageView = customImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
//        imageView.backgroundColor = .red
        imageView.image = #imageLiteral(resourceName: "plus_photo")
        return imageView
    }()
    
    let optionsButton:UIButton = {
        let button = UIButton()
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    let userNameLabel:UILabel = {
        let label = UILabel()
//        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postImageView:customImageView = {
        let imageView = customImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
//        imageView.backgroundColor = .orange

        return imageView
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "send2").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon").withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    let captionLabel:UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 0
        return label
    }()
    
    func attributedText(){
        guard let post = post else{
            return
        }
        let attributedText = NSMutableAttributedString(string: "\(post.user.username)", attributes: [NSAttributedString.Key.font :UIFont.boldSystemFont(ofSize: 14) ])
        attributedText.append(NSAttributedString(string: " \(post.caption)", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 4)]))
        attributedText.append(NSAttributedString(string: "1 Week ago", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:UIColor.gray]))
        
        captionLabel.attributedText = attributedText
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = .gray
        addSubview(userProfileImageView)
        addSubview(userNameLabel)
        addSubview(optionsButton)
        addSubview(postImageView)

        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 40, height: 40)
        userProfileImageView.layer.cornerRadius = 40/2
        
        userNameLabel.anchor(top: topAnchor, left: userProfileImageView.rightAnchor, bottom: postImageView.topAnchor, right: optionsButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        optionsButton.anchor(top: topAnchor, left: nil, bottom: postImageView.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 40, height: 0)
        
        
        
        
        postImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        postImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        setUpButtons()
        addSubview(captionLabel)
        captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpButtons(){
       let stackView = UIStackView(arrangedSubviews: [likeButton,commentButton,sendMessageButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
//        stackView.backgroundColor = .green
        addSubview(stackView)
        
        stackView.anchor(top: postImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: leftAnchor, paddingTop: 0, paddingLeft: 4, paddingBottom: 0, paddingRight: 0, width: 120, height: 50)
        
        addSubview(bookmarkButton)

        bookmarkButton.anchor(top: postImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 8, width: 40, height: 60)
        
        
         
        

    }
}
