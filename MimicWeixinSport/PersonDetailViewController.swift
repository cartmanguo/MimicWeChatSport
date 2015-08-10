//
//  PersonDetailViewController.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/4.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
class PersonDetailViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    var userData:UserData?
    @IBOutlet weak var heightConstaint: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    @IBOutlet weak var height2: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var bgImageView: UIImageView!
    var bgImage:UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        bgImageView.image = bgImage
        //scrollView.contentSize = CGSizeMake(view.frame.size.width,view.frame.size.height + 200)
        //println("\(userData?.name)")
        height.constant = view.frame.size.height-50
        containerView.layoutIfNeeded()
        //heightConstaint.active = true
        self.title = userData!.name! + "的主页"
        // Do any additional setup after loading the view.
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
