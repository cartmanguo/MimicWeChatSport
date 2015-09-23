//
//  PhotoCell.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/10.
//  Copyright (c) 2015年 randy. All rights reserved.
//
protocol CheckmarkPressedDelegate
{
    func didSelectAsset(cellForAsset:PhotoCell)
    func didDeSelectAsset(cellForAsset:PhotoCell)
}
import UIKit
import AssetsLibrary
class PhotoCell: UICollectionViewCell {
    var delegate:CheckmarkPressedDelegate?
    var asset:ALAsset?
    var isAssetSelected:Bool = false
    var checkmarkButton:UIButton?
    var thumbnailImgView:UIImageView?
    var allowMultibleSelection = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        thumbnailImgView = UIImageView(frame: self.bounds)
        let multi = NSUserDefaults.standardUserDefaults().boolForKey("multi_key")
        self.allowMultibleSelection = multi
        self.addSubview(thumbnailImgView!)
        if self.allowMultibleSelection
        {
            checkmarkButton = UIButton(type: .Custom)
            checkmarkButton?.backgroundColor = UIColor.clearColor()
            checkmarkButton?.setBackgroundImage(UIImage(named: "photo_check_default"), forState: .Normal)
            checkmarkButton?.setBackgroundImage(UIImage(named: "photo_check_selected"), forState: UIControlState.Selected)
            checkmarkButton?.addTarget(self, action: "selectAsset:", forControlEvents: .TouchUpInside)
            checkmarkButton?.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(checkmarkButton!)
        }
    }
    
    func selectAsset(selected:Bool)
    {
        if checkmarkButton!.selected
        {
            self.delegate?.didDeSelectAsset(self)
        }
        else
        {
            UIView.animateWithDuration(0.2, animations: {() in
                self.checkmarkButton!.transform = CGAffineTransformMakeScale(1.2, 1.2)
                }, completion: {(finished) in
                    UIView.animateWithDuration(0.2, animations: {() in
                        self.checkmarkButton!.transform = CGAffineTransformIdentity
                    })
            })
            self.delegate?.didSelectAsset(self)
        }
    }
    
    func setCellSelected(selected:Bool)
    {
        checkmarkButton?.selected = selected
    }
    
    func setAssetForCell(asset:ALAsset,selected:Bool)
    {
        setCellSelected(selected)
        let thumbnaimImg = asset.thumbnail().takeUnretainedValue()
        self.asset = asset
        thumbnailImgView?.image = UIImage(CGImage: thumbnaimImg)
    }
    
    override func layoutSubviews() {
        if self.allowMultibleSelection
        {
            //let cellSize = self.frame.size
            let widthConstaint = NSLayoutConstraint.constraintsWithVisualFormat("H:[checkmarkButton(==25)]", options: [], metrics: nil, views: ["checkmarkButton":checkmarkButton!])
            let heightConstaint = NSLayoutConstraint.constraintsWithVisualFormat("V:[checkmarkButton(==25)]", options: [], metrics: nil, views: ["checkmarkButton":checkmarkButton!])
            checkmarkButton?.addConstraints(widthConstaint)
            checkmarkButton?.addConstraints(heightConstaint)
            let trailing = NSLayoutConstraint.constraintsWithVisualFormat("H:[checkmarkButton]-2-|", options: [], metrics: nil, views: ["checkmarkButton":checkmarkButton!])
            let top = NSLayoutConstraint.constraintsWithVisualFormat("V:|-2-[checkmarkButton]", options: [], metrics: nil, views: ["checkmarkButton":checkmarkButton!])
            self.addConstraints(trailing)
            self.addConstraints(top)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
}
