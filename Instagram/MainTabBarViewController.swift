//
//  MainTabBarViewController.swift
//  Instagram
//
//  Created by prog on 4/15/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarViewController: UITabBarController,UITabBarControllerDelegate{
    
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelector = PhotoSelectorViewController(collectionViewLayout: layout)
            let navigationController = UINavigationController(rootViewController: photoSelector)
            present(navigationController, animated: true, completion: nil)
            return false
        }
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self 
//        view.backgroundColor = .red
        // Do any additional setup after loading the view.
        //open login screen if there is no current user
        
        
        
        
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let loginController = LoginViewController()
                let navController = UINavigationController(rootViewController: loginController)
                self.present(navController, animated: true, completion: nil)
            }


            return
        }
        setUpViewController()
//
    }
    
    func setUpViewController(){
        let homeNavController = templateViewController(selectedImage:#imageLiteral(resourceName: "home_selected"), unselectedImage: #imageLiteral(resourceName: "home_unselected"), rootViewController: HomeViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let searchNavController = templateViewController(selectedImage: #imageLiteral(resourceName: "search_selected"), unselectedImage: #imageLiteral(resourceName: "search_unselected"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
         let userProfileController = templateViewController(selectedImage:#imageLiteral(resourceName: "profile_selected"), unselectedImage: #imageLiteral(resourceName: "profile_unselected"), rootViewController: UserProfileViewController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        let likecontroller = templateViewController(selectedImage: #imageLiteral(resourceName: "like_selected"), unselectedImage: #imageLiteral(resourceName: "like_unselected"))
        let plusNavController = templateViewController(selectedImage: #imageLiteral(resourceName: "plus_unselected"), unselectedImage: #imageLiteral(resourceName: "plus_unselected"))
        
        
        tabBar.tintColor = .black
        
        
        viewControllers = [
                            homeNavController,
                            userProfileController,
                           plusNavController,
                           searchNavController,
                           likecontroller,
                          ]
        guard let items = tabBar.items else {
            return
        }
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
    }
    
    func templateViewController (selectedImage:UIImage,unselectedImage:UIImage,rootViewController:UIViewController = UIViewController())->UINavigationController{
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem.image = unselectedImage
        navigationController.tabBarItem.selectedImage = selectedImage
        return navigationController
        
    }

}
