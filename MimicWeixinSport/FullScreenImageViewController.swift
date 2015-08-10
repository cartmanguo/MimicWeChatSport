//
//  FullScreenImageViewController.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/10.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
protocol UsePhotoDelegate
{
    func setBackgroundImage(image:UIImage)
}
class FullScreenImageViewController: UIViewController {
    var imageView:UIImageView = UIImageView()
    var image:UIImage?
    var delegate:UsePhotoDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor()
        imageView.frame = view.frame
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = image
        view.addSubview(imageView)
        let useButton = UIBarButtonItem(title: "使用", style: UIBarButtonItemStyle.Plain, target: self
        , action: "usePhoto")
        self.navigationItem.rightBarButtonItem = useButton
        useButton.tintColor = UIColor(red: 21/255, green: 160/255, blue: 44/255, alpha: 1.0)
    }
    
    func usePhoto()
    {
        NSNotificationCenter.defaultCenter().postNotificationName("SetImageNoti", object: image)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
