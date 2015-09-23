//
//  UINavigationController+StatusBarStyle.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/3.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
class MyNavigationController:UINavigationController,UIGestureRecognizerDelegate
{
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.topViewController!.preferredStatusBarStyle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let target = self.interactivePopGestureRecognizer!.delegate
        let pan = UIPanGestureRecognizer(target: target!, action: "handleNavigationTransition:")
        pan.delegate = self
        view.addGestureRecognizer(pan)
        self.interactivePopGestureRecognizer!.enabled = false
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if self.viewControllers.count == 1
        {
            return false
        }
        return true
    }
    
}
