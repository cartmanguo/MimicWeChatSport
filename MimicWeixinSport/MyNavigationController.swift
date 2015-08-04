//
//  UINavigationController+StatusBarStyle.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/3.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
class MyNavigationController:UINavigationController
{
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return self.topViewController.preferredStatusBarStyle()
    }
}
