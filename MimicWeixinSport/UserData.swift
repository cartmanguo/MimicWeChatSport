//
//  UserData.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/3.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit

class UserData: NSObject {
    var name:String?
    var steps:Int?
    init(name:String,steps:Int)
    {
        self.name = name
        self.steps = steps
    }
}
