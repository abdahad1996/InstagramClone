//
//  UserProfileCollectionViewCell.swift
//  Instagram
//
//  Created by prog on 4/21/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit

class UserProfileHeaderCell: UICollectionViewCell {
    
    var user:User? {
        didSet{
            guard let urlString = user?.userProfileImageUrl else{return}
//            setProfileImage()
            profileImage.loadImageURL(urlString: urlString)
            userNameLabel.text = user?.username
            
        }
    }
    
    let profileImage:customImageView = {
        let image = customImageView()
        image.image = #imageLiteral(resourceName: "plus_photo")
        image.contentMode = .scaleToFill
        image.clipsToBounds = true
        return image
    }()
    let userNameLabel : UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    let gridButton :UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "grid") , for: .normal)
        return button
    }()
    let listButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "list")
            , for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    let bookmarkButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "ribbon")
            , for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    let postsLabel : UILabel = {
        let label = UILabel()
        label.text = "posts"
        label.textAlignment = .center
        label.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray,
             NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13)]))
        label.attributedText = attributedText

        return label
    }()
    let followersLabel : UILabel = {
        let label = UILabel()
        label.text = "followers"
        label.textAlignment = .center
        label.numberOfLines = 0
        
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray,
         NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13)]))
        label.attributedText = attributedText
        return label
    }()
    let followingLabel : UILabel = {
        let label = UILabel()
        label.text = "following"
        label.textAlignment = .center
        label.numberOfLines = 0
        let attributedText = NSMutableAttributedString(string: "15\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 15)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray,
NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 13)]))
        label.attributedText = attributedText

        return label
    }()
    let editProfileButton : UIButton = {
        let button = UIButton()
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 3

        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImage)
        profileImage.anchor(top: self.topAnchor, left: self.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 80, height: 80)
        profileImage.layer.cornerRadius = 80/2
        profileImage.clipsToBounds = true
        
        setUpBottomToolBar()
        
        addSubview(userNameLabel)
        userNameLabel.anchor(top: profileImage.bottomAnchor, left: self.leftAnchor, bottom: self.gridButton.topAnchor , right: self.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        setUpUserStats()
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postsLabel.bottomAnchor, left: profileImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 2, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 34)
        
    }
    func setUpUserStats(){
        let stackView = UIStackView(arrangedSubviews: [postsLabel,followersLabel,followingLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        stackView.backgroundColor = .gray
        stackView.anchor(top: topAnchor, left: profileImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
    }
    func setUpBottomToolBar(){
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.gray
        addSubview(topDividerView)
        
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.gray
        addSubview(bottomDividerView)
        
        let stackView = UIStackView(arrangedSubviews: [gridButton,listButton,bookmarkButton])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        addSubview(stackView)
        
        topDividerView.anchor(top: nil, left: self.leftAnchor, bottom: stackView.topAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
        stackView.anchor(top: topDividerView.bottomAnchor, left: self.leftAnchor, bottom: bottomDividerView.topAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: self.leftAnchor, bottom: self.bottomAnchor, right: self.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
//
//    func setProfileImage(){
//        guard let imageUrl = user?.userProfileImageUrl else {
//            return
//        }
//        guard let url = URL(string: imageUrl)else{
//            return
//        }
//        customImageView.loadImageURL(url.absoluteString)
////        URLSession.shared.dataTask(with: url) { (data, res, err) in
////            if let error = err {
////                print("error is \(error.localizedDescription)")
////            }
////            guard  let data = data else {
////                return
////            }
////            let image = UIImage(data: data)
////            DispatchQueue.main.async {
////                self.profileImage.image = image
////            }
////
////
////        }.resume()
//    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
