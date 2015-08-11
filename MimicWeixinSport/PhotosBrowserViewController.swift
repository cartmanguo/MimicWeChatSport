//
//  PhotosBrowserViewController.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/11.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
import AssetsLibrary
class PhotosBrowserViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var photoAssets:[ALAsset] = []
    init(collectionViewLayout layout: UICollectionViewLayout,photoAssets:[ALAsset]) {
        super.init(collectionViewLayout: layout)
        self.photoAssets = photoAssets
        self.collectionView?.pagingEnabled = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionView?.registerClass(AssetCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    override func viewDidLoad() {
        self.collectionView?.frame = CGRectMake(-10, 0, self.collectionView!.frame.size.width + 20, self.collectionView!.frame.size.height)

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(view.frame.size.width+20, view.frame.size.height)
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoAssets.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! AssetCell
        let asset = photoAssets[indexPath.row]
        cell.setAssetForCell(asset)
        //println("\(cell.fullImageView.frame)")
        return cell
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
