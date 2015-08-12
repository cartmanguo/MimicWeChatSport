//
//  GCBadgeButton.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/11.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
@IBDesignable
class GCBadgeButton: UIView {
    var button:UIButton?
    var badgeNum:String?
    var badgeLabel:UILabel?
    var containerView:UIView?
    override init(frame: CGRect) {
        super.init(frame: frame)
        containerView = UIView(frame: CGRectMake(0, 0, 60, 25))
        //containerView?.backgroundColor = UIColor.orangeColor()
        badgeLabel = UILabel(frame: CGRectMake(5, 0, 25, 25))
        badgeLabel?.font = UIFont.systemFontOfSize(15)
        badgeLabel?.backgroundColor = UIColor(red: 21/255, green: 160/255, blue: 44/255, alpha: 1.0)
        badgeLabel?.textColor = UIColor.whiteColor()
        badgeLabel?.clipsToBounds = true
        badgeLabel?.textAlignment = NSTextAlignment.Center
        badgeLabel?.layer.cornerRadius = badgeLabel!.frame.size.width/2
        badgeLabel?.hidden = true
        containerView?.addSubview(badgeLabel!)
        button = UIButton.buttonWithType(.Custom) as? UIButton
        button?.setTitleColor(UIColor(red: 21/255, green: 160/255, blue: 44/255, alpha: 1.0), forState: .Normal)
        button?.frame = CGRectMake(badgeLabel!.frame.size.width+10, 0, 35, 25)
        button?.setTitle("发送", forState: .Normal)
        button?.enabled = false
        button?.alpha = 0.5
        button?.addTarget(self, action: "test", forControlEvents: .TouchUpInside)
        button?.titleLabel?.font = UIFont.systemFontOfSize(15)
        containerView?.addSubview(button!)
        self.addSubview(containerView!)
    }
    
    func test()
    {
        print("yeah")
    }
    
    func setBadgeNumber(badgeNum:Int)
    {
        self.badgeNum = String(format: "%d", badgeNum)
        if badgeNum == 0
        {
            badgeLabel?.hidden = true
            button?.enabled = false
            button?.alpha = 0.5
        }
        else
        {
            badgeLabel?.hidden = false
            button?.enabled = true
            button?.alpha = 1.0
            badgeLabel?.text = String(format: "%d", badgeNum)
            badgeLabel?.transform = CGAffineTransformMakeScale(0, 0)

//            UIView.animateWithDuration(0.2, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0,options: nil, animations: {() in
//                self.badgeLabel!.transform = CGAffineTransformMakeScale(1.1,1.1)
//                }, completion: {(finished) in
//                    UIView.animateWithDuration(0.1, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.0, options: nil, animations: {() in
//                        self.badgeLabel?.transform = CGAffineTransformIdentity
//                        }, completion: {(finished) in
//                    })
//            })
            UIView.animateWithDuration(0.2, animations: {() in
                self.badgeLabel!.transform = CGAffineTransformMakeScale(1.1,1.1)
                }, completion: {(finished) in
                    UIView.animateWithDuration(0.1, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.0, options: nil, animations: {() in
                        self.badgeLabel?.transform = CGAffineTransformIdentity
                        }, completion: {(finished) in
                    })
            })
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
