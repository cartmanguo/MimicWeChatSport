//
//  PhotosCollectionViewController.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/10.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
import AssetsLibrary

class PhotosCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout,CheckmarkPressedDelegate {
    let reuseIdentifier = "Cell"
    var albumsAsset:ALAssetsGroup?
    var allowMultipleSelection:Bool = false
    var assetsArray:[ALAsset] = []
    var selectedAssets:[ALAsset] = []
    let cellSize = (UIScreen.mainScreen().bounds.size.width-10)/4
    var sendButton:GCBadgeButton?
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
        if allowMultipleSelection
        {
            setupToolBar()
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.toolbarHidden = !allowMultipleSelection
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.toolbarHidden = true
    }
    
    func setupToolBar()
    {
        let previewBarButton = UIBarButtonItem(title: "预览", style: .Plain, target: self, action: "showPreview")
        previewBarButton.tintColor = UIColor.blackColor()
        previewBarButton.enabled = false
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        sendButton = GCBadgeButton(frame: CGRectMake(0, 0, 60, 25))
        let sendBarButton = UIBarButtonItem(customView: sendButton!)
        self.setToolbarItems([previewBarButton,space,sendBarButton],animated:false)
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
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! PhotoCell
        cell.delegate = self
        cell.allowMultibleSelection = allowMultipleSelection
        cell.layoutSubviews()
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
        if allowMultipleSelection
        {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumInteritemSpacing = 0
            flowLayout.minimumLineSpacing = 0
            flowLayout.scrollDirection = UICollectionViewScrollDirection.Horizontal
            let browseVC = PhotosBrowserViewController(collectionViewLayout: flowLayout, photoAssets:assetsArray)
            self.navigationController?.pushViewController(browseVC, animated: true)
        }
        else
        {
            let fullScreenVC = FullScreenImageViewController()
            fullScreenVC.image = UIImage(CGImage: originalImage)
            self.navigationController?.pushViewController(fullScreenVC, animated: true)

        }
    }
    
    func isAssetSelected(selectAsset:ALAsset)->Bool
    {
        if selectedAssets.count == 0
        {
            selectedAssets.append(selectAsset)
            return false
        }
        for asset in selectedAssets
        {
            let urlForAsset = asset.valueForProperty(ALAssetPropertyAssetURL) as! NSURL
            let urlForSelectAsset = selectAsset.valueForProperty(ALAssetPropertyAssetURL) as! NSURL
            if urlForAsset.isEqual(urlForSelectAsset)
            {
                return true
            }
        }
        selectedAssets.append(selectAsset)
        return false
    }
    
    func didSelectAsset(cellForAsset:PhotoCell)
    {
        if selectedAssets.count == 9
        {
            let alertController = UIAlertController(title: "你最多只能选择9张照片", message: "", preferredStyle: .Alert)
            let action = UIAlertAction(title: "分かった", style: UIAlertActionStyle.Default, handler: nil)
            alertController.addAction(action)
            presentViewController(alertController, animated: true, completion: nil)
        }
        else
        {
            cellForAsset.setCellSelected(!isAssetSelected(cellForAsset.asset!))
            println("cnt:\(selectedAssets.count),\(cellForAsset.asset?.valueForProperty(ALAssetPropertyAssetURL))")
            sendButton?.setBadgeNumber(selectedAssets.count)
        }
        let previewBarButton = self.toolbarItems![0] as! UIBarButtonItem
        previewBarButton.enabled = true

    }
    
    func didDeSelectAsset(cellForAsset:PhotoCell)
    {
        let idx = find(selectedAssets, cellForAsset.asset!)
        if let assetIndex = idx
        {
            selectedAssets.removeAtIndex(assetIndex)
            sendButton?.setBadgeNumber(selectedAssets.count)
            cellForAsset.setCellSelected(false)
            println("cnt:\(selectedAssets.count),\(cellForAsset.asset?.valueForProperty(ALAssetPropertyAssetURL))")
            if(selectedAssets.count == 0)
            {
                let previewBarButton = self.toolbarItems![0] as! UIBarButtonItem
                previewBarButton.enabled = false
            }
        }
    }
}
