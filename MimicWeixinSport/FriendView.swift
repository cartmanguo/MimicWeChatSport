//
//  FriendView.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/3.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit

class FriendView: UIView {
    var userData:UserData?
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var numOfLikesLabel: UILabel!

    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var numOfStepsLabel: UILabel!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var progressBar: UIProgressView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func setColor(userData:UserData)
    {
        if userData.steps!/10000 >= 1
        {
            progressBar.progressTintColor = UIColor.orangeColor()
            
        }
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
