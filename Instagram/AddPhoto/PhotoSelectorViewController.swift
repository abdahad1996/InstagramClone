//
//  PhotoSelectorViewController.swift
//  Instagram
//
//  Created by prog on 4/21/19.
//  Copyright © 2019 prog. All rights reserved.
//

import UIKit
import Photos

private let cellIdentifier = "Cell"
private let headerIdentifier = "header"


class PhotoSelectorViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        collectionView.backgroundColor = .white
        self.collectionView!.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.collectionView.register(PhotoSelector_Header.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        
        setUpNavigationButtons()
        fetchPhotos()
        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    var images = [UIImage]()
    var selectedImage :UIImage?
    var assets = [PHAsset]()
    
    func fetchAssets () -> PHFetchOptions {
        //fetching assests and that too sorted with creation data
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 10
        let sortDiscriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDiscriptor]
        return fetchOptions
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("\(indexPath.item)")
        self.selectedImage = images[indexPath.item]
        self.collectionView.reloadData()
        
        let indexpath0 = IndexPath(item: 0, section: 0)
        self.collectionView.scrollToItem(at: indexpath0, at: .bottom, animated: true)
        
    }
    func fetchPhotos(){
       
        // load all assets with the options created above
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchAssets())
        print("hello")
        print(allPhotos.count)
        
        //image manager to manage the assets and retrieve  the images
        DispatchQueue.global(qos: .background).async {
            allPhotos.enumerateObjects { (asset, count, stop) in
                print(count)
                
                //target size bigger it takes more time so we use background thread and load ui in main thread
                // also we show header picture in high resoltion by fetching all assets and then retreiving just one image. also when fetching all assets make sure target size is low to fetch without delay
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200,height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    if let image = image {
                        self.images.append(image)
                        self.assets.append(asset)
                    }
                    if self.selectedImage == nil {
                        self.selectedImage = image
                    }
                    //reload the collectionview when all images retrieved and added to images array
                    if count == allPhotos.count-1{
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                            
                        }
                    }
                })
            }
            
        }
       
        
    }
    func setUpNavigationButtons(){
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
    }
    @objc func handleCancel () {
        self.dismiss(animated: true, completion: nil)
    }
    @objc func handleShare(){
        let photoShareController = SharePhotoController()
        navigationController?.pushViewController(photoShareController, animated: true)
        photoShareController.selectedImage = header?.photoImageView.image
    }

   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 1, left: 0, bottom: 0, right: 0)
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return images.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.view.frame.size.width-3)/4
        return CGSize(width: width, height: width)
    }

    override func collectionView(_ cellIdentifierw: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! PhotoSelectorCell
        
        print(images.count)
        cell.photoImageView.image = images[indexPath.item]
        // Configure the cell
    
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.width)
    }
    
    var header:PhotoSelector_Header?
    
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! PhotoSelector_Header
        self.header = header
        
        header.photoImageView.image = selectedImage
        //get index of selectedimage
        if let selectedImage = selectedImage{
            if let index = self.images.firstIndex(of: selectedImage)
            {
                let selectedAsset = self.assets[index]
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 600, height: 600)
                
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { (image, info) in
                    header.photoImageView.image = image
//                    self.collectionView.reloadData()
                }
                
                
                
            }
        }
        
        
        return header
        
    }
}
