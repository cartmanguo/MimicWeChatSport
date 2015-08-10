//
//  PhotoCell.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/10.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
import AssetsLibrary
class PhotoCell: UICollectionViewCell {
    var checkmarkButton:UIButton?
    var thumbnailImgView:UIImageView?
    var allowMultibleSelection = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        thumbnailImgView = UIImageView(frame: self.bounds)
        self.addSubview(thumbnailImgView!)
        if self.allowMultibleSelection
        {
            checkmarkButton = UIButton.buttonWithType(.Custom) as? UIButton
            checkmarkButton?.backgroundColor = UIColor.clearColor()
            checkmarkButton?.setBackgroundImage(UIImage(named: "photo_check_default"), forState: .Normal)
            checkmarkButton?.setBackgroundImage(UIImage(named: "photo_check_selected"), forState: UIControlState.Selected)
            checkmarkButton?.addTarget(self, action: "selectAsset:", forControlEvents: .TouchUpInside)
            checkmarkButton?.setTranslatesAutoresizingMaskIntoConstraints(false)
            self.addSubview(checkmarkButton!)
        }
        

    }
    
    func selectAsset(sender:UIButton)
    {
        if sender.selected
        {
            sender.selected = false
        }
        else
        {
            sender.selected = true
            UIView.animateWithDuration(0.2, animations: {() in
                sender.transform = CGAffineTransformMakeScale(1.1, 1.1)
                }, completion: {(finished) in
                    UIView.animateWithDuration(0.2, animations: {() in
                        sender.transform = CGAffineTransformIdentity
                    })
            })
        }
    }
    
    func setAssetForCell(asset:ALAsset)
    {
        let thumbnaimImg = asset.thumbnail().takeUnretainedValue()
        thumbnailImgView?.image = UIImage(CGImage: thumbnaimImg)
    }
    
    override func layoutSubviews() {
        if self.allowMultibleSelection
        {
            let cellSize = self.frame.size
            let widthConstaint = NSLayoutConstraint.constraintsWithVisualFormat("H:[checkmarkButton(==25)]", options: nil, metrics: nil, views: ["checkmarkButton":checkmarkButton!])
            let heightConstaint = NSLayoutConstraint.constraintsWithVisualFormat("V:[checkmarkButton(==25)]", options: nil, metrics: nil, views: ["checkmarkButton":checkmarkButton!])
            checkmarkButton?.addConstraints(widthConstaint)
            checkmarkButton?.addConstraints(heightConstaint)
            let trailing = NSLayoutConstraint.constraintsWithVisualFormat("H:[checkmarkButton]-2-|", options: nil, metrics: nil, views: ["checkmarkButton":checkmarkButton!])
            let top = NSLayoutConstraint.constraintsWithVisualFormat("V:|-2-[checkmarkButton]", options: nil, metrics: nil, views: ["checkmarkButton":checkmarkButton!])
            self.addConstraints(trailing)
            self.addConstraints(top)
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
