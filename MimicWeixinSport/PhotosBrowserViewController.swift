//
//  PhotosBrowserViewController.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/11.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
import AssetsLibrary
protocol PhotoBrowserDelegate
{
    func seletedPhotosNumberInPhotoBrowser(browser:PhotosBrowserViewController)->Int
    func isAssetSelectedInBrowser(browser:PhotosBrowserViewController,asset:ALAsset)->Bool
    func selectAssetInBrowser(browser:PhotosBrowserViewController,asset:ALAsset)->Bool
    func deSelectAssetInBrowser(browser:PhotosBrowserViewController,asset:ALAsset)
}
class PhotosBrowserViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    var photoAssets:[ALAsset] = []
    var currentIndex:Int?
    var delegate:PhotoBrowserDelegate?
    var sendButton:GCBadgeButton!
    var toolbar:UIToolbar!
    init(collectionViewLayout layout: UICollectionViewLayout,photoAssets:[ALAsset],currentIndex:Int) {
        super.init(collectionViewLayout: layout)
        self.photoAssets = photoAssets
        self.currentIndex = currentIndex
        self.collectionView?.pagingEnabled = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.collectionView?.registerClass(AssetCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    override func viewDidLoad() {
        self.collectionView?.frame = CGRectMake(-10, 0, self.collectionView!.frame.size.width + 20, self.collectionView!.frame.size.height)
        self.view.clipsToBounds = true
        let selectBarButton = UIBarButtonItem(image: UIImage(named: "photo_check_default"), style: .Plain, target: self, action: "selectAsset")
        self.navigationItem.rightBarButtonItem = selectBarButton
        self.title = "\(currentIndex!+1)"+"/"+"\(photoAssets.count)"
    }
    
    override func viewWillAppear(animated: Bool) {
        //collectionView?.scrollToItemAtIndexPath(NSIndexPath(forItem: currentIndex!, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        collectionView?.setContentOffset(CGPointMake(collectionView!.frame.size.width * CGFloat(currentIndex!), 0), animated: false)
        let xOffset = collectionView?.contentOffset.x
        let index = Int(xOffset!/(view.frame.size.width+20))
        let asset = photoAssets[index]
        if (delegate?.isAssetSelectedInBrowser(self, asset: asset) == true)
        {
            navigationItem.rightBarButtonItem?.image = UIImage(named: "photo_check_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

        }
        else
        {
            navigationItem.rightBarButtonItem?.image = UIImage(named: "photo_check_default")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }
        setupToolbar()
    }
    
    func selectAsset()
    {
        let xOffset = collectionView?.contentOffset.x
        let index = Int(xOffset!/(view.frame.size.width+20))
        print("current:\(index)")
        let asset = photoAssets[index]
        if (delegate?.isAssetSelectedInBrowser(self, asset: asset) == true)
        {
            print("remove")
            delegate?.deSelectAssetInBrowser(self, asset: asset)
            sendButton.setBadgeNumber(delegate!.seletedPhotosNumberInPhotoBrowser(self))
            navigationItem.rightBarButtonItem?.image = UIImage(named: "photo_check_default")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }
        else
        {
            if delegate?.seletedPhotosNumberInPhotoBrowser(self) < 9
            {
                sendButton.setBadgeNumber(delegate!.seletedPhotosNumberInPhotoBrowser(self))
                delegate?.selectAssetInBrowser(self, asset: asset)
                navigationItem.rightBarButtonItem?.image = UIImage(named: "photo_check_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            }
            else
            {
                let alertController = UIAlertController(title: "你最多只能选择9张照片", message: "", preferredStyle: .Alert)
                let action = UIAlertAction(title: "分かった", style: UIAlertActionStyle.Default, handler: nil)
                alertController.addAction(action)
                presentViewController(alertController, animated: true, completion: nil)
            }
            
        }
        sendButton.setBadgeNumber(delegate!.seletedPhotosNumberInPhotoBrowser(self))
    }
    
    func setupToolbar()
    {
        toolbar = UIToolbar(frame: CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40))
        toolbar.translucent = true
        view.addSubview(toolbar)
        toolbar.barTintColor = UIColor(red: 6/255, green: 6/255, blue: 6/255, alpha: 1.0)
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let selectedNum = self.delegate?.seletedPhotosNumberInPhotoBrowser(self)
        sendButton = GCBadgeButton(frame: CGRectMake(0, 0, 60, 25))
        sendButton.setBadgeNumber(selectedNum!)
        let sendBarButton = UIBarButtonItem(customView: sendButton!)
        toolbar.items = [space,sendBarButton]
    }
    
    func setupNavigationBar()
    {
        
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
    
    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let xOffset = collectionView?.contentOffset.x
        let index = Int(xOffset!/(view.frame.size.width+20))
        currentIndex = index
        self.title = "\(currentIndex!+1)"+"/"+"\(photoAssets.count)"

        let asset = photoAssets[index]
        if (delegate?.isAssetSelectedInBrowser(self, asset: asset) == true)
        {
            navigationItem.rightBarButtonItem?.image = UIImage(named: "photo_check_selected")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }
        else
        {
            navigationItem.rightBarButtonItem?.image = UIImage(named: "photo_check_default")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        }
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
