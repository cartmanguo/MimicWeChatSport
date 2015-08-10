//
//  PhotosCollectionViewController.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/10.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
import AssetsLibrary

class PhotosCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    let reuseIdentifier = "Cell"
    var albumsAsset:ALAssetsGroup?
    var assetsArray:[ALAsset] = []
    let cellSize = (UIScreen.mainScreen().bounds.size.width-10)/4
    
    init(collectionViewLayout layout: UICollectionViewLayout,assetsGroup:ALAssetsGroup) {
        super.init(collectionViewLayout: layout)
        self.albumsAsset = assetsGroup
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: nil, action: nil)
        loadData()
        self.title = albumsAsset?.valueForProperty(ALAssetsGroupPropertyName) as? String
        collectionView?.backgroundColor = UIColor.whiteColor()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.registerClass(PhotoCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    func loadData()
    {
        self.albumsAsset?.setAssetsFilter(ALAssetsFilter.allPhotos())
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {() in
            self.albumsAsset?.enumerateAssetsWithOptions(NSEnumerationOptions.Reverse, usingBlock: {(asset,index,pointer) in
                if let photoAsset = asset
                {
                    self.assetsArray.insert(photoAsset, atIndex: 0)
                }
            })
            println("cnt:\(self.assetsArray.count)")
            dispatch_async(dispatch_get_main_queue(), {() in
                self.collectionView?.reloadData()
            })
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }


    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return assetsArray.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCell
        let asset = self.assetsArray[indexPath.row]
        cell.setAssetForCell(asset)
        // Configure the cell
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: cellSize, height: cellSize)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let asset = self.assetsArray[indexPath.row]
        let originalImage = asset.defaultRepresentation().fullScreenImage().takeUnretainedValue()
        let fullScreenVC = FullScreenImageViewController()
        fullScreenVC.image = UIImage(CGImage: originalImage)
        self.navigationController?.pushViewController(fullScreenVC, animated: true)
    }
    

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return false
    }

    override func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
    
    }
    */

}
