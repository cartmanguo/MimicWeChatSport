//
//  ViewController.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/3.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit

class SportViewController : UIViewController,UIScrollViewDelegate,MimicActionSheetDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    var friendsRankContainer: UIView!
    var numberOfData:Int = 9
    let cellHeight:CGFloat = 65
    var threshold:CGFloat?
    var userDatas:[UserData]?
    @IBOutlet weak var championView: UIView!
    @IBOutlet weak var championNameLabel: UILabel!
    @IBOutlet weak var bgImgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "setBackgroundImage:", name: "SetImageNoti", object: nil)
        let tap = UITapGestureRecognizer(target: self, action: "showActionSheet:")
        tap.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tap)
        let userData1 = UserData(name: "Alan", steps: 7894)
        let userData2 = UserData(name: "Jim", steps: 1234)
        let userData3 = UserData(name: "Steve", steps: 2546)
        let userData4 = UserData(name: "Guo", steps: 1345)
        let userData5 = UserData(name: "Kobe", steps: 3451)
        let userData6 = UserData(name: "Jeremy", steps: 5678)
        let userData7 = UserData(name: "James", steps: 6543)
        let userData8 = UserData(name: "Dean", steps: 8888)
        let userData9 = UserData(name: "Cartman", steps: 999999)
        userDatas = [userData1,userData2,userData3,userData4,userData5,userData6,userData7,userData8,userData9]
        userDatas?.sortInPlace({(s1:UserData,s2:UserData)->Bool in
            return s1.steps > s2.steps
        })
        let champ = userDatas![0] as UserData
        championNameLabel.text = champ.name! + "占领了封面"
        friendsRankContainer = UIView(frame: CGRectMake(5, scrollView.frame.size.height/2, view.frame.size.width - 10, cellHeight*CGFloat(numberOfData)))
        scrollView.addSubview(friendsRankContainer)
        friendsRankContainer.backgroundColor = UIColor.whiteColor()
        friendsRankContainer.layer.cornerRadius = 4
        friendsRankContainer.layer.masksToBounds = true
        
        if friendsRankContainer.frame.origin.y + friendsRankContainer.frame.size.height - view.frame.size.height < 0
        {
            scrollView.contentSize = CGSizeMake(view.frame.size.width, scrollView.frame.size.height+100)
        }
        else
        {
            scrollView.contentSize = CGSizeMake(view.frame.size.width, view.frame.size.height + abs(friendsRankContainer.frame.origin.y + friendsRankContainer.frame.size.height - view.frame.size.height))
        }
        threshold = friendsRankContainer.frame.origin.y - 64
        for i in 0 ..< numberOfData
        {
            let tapGesture = UITapGestureRecognizer(target: self, action: "toPersonDetail:")
            tapGesture.numberOfTapsRequired = 1
            let friendView = NSBundle.mainBundle().loadNibNamed("FriendView", owner: self, options: nil).first as! FriendView
            friendView.addGestureRecognizer(tapGesture)
            let data = userDatas![i] as UserData
            friendView.userData = data
            friendView.stepsLabel.text = data.name
            friendView.numOfStepsLabel.text = String(format: "%d", data.steps!)
            friendView.progressBar.progress = Float(data.steps!)/10000.0
            friendView.setColor(data)
            let frame = CGRectMake(-1, cellHeight*CGFloat(i)-1, friendsRankContainer.frame.size.width+2, cellHeight)
            friendView.rankLabel.text = String(format: "%d", i+1)
            friendView.frame = frame
            friendsRankContainer.addSubview(friendView)
            let separatorLine = UIView(frame: CGRectMake(0, 0, friendView.frame.size.width, 0.5))
            separatorLine.backgroundColor = UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
            friendView.addSubview(separatorLine)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func toImageBrowser(sender: AnyObject)
    {
        let albumsVC = AlbumsTableViewController()
        albumsVC.allowMultipleSelection = true
        let customNav = MyNavigationController(rootViewController: albumsVC)
        presentViewController(customNav, animated: true, completion: nil)
        NSUserDefaults.standardUserDefaults().setObject(albumsVC.allowMultipleSelection, forKey: "multi_key")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func setBackgroundImage(notification:NSNotification)
    {
        let image = notification.object as? UIImage
        if let bgImage = image
        {
            self.bgImgView.image = bgImage
        }
    }
    
    func toPersonDetail(tap:UIGestureRecognizer)
    {
        let friendView = tap.view as! FriendView
        let userData = friendView.userData
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Person") as! PersonDetailViewController
        detailVC.userData = userData
        detailVC.bgImage = self.bgImgView.image
        navigationController?.pushViewController(detailVC, animated: true)
    }
    @IBAction func reset(sender: AnyObject) {
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //println("\(scrollView.contentOffset.y)")
        if scrollView.contentOffset.y - threshold! >= 0
        {
            //println("should move up:\(scrollView.contentOffset.y - threshold!)")
            championView.frame.origin.y = 0 - (scrollView.contentOffset.y - threshold!)+64
        }
        else
        {
            if championView.frame.origin.y != 64
            {
                championView.frame.origin.y += 64 - championView.frame.origin.y
            }
        }        
    }
    
   func showActionSheet(sender: AnyObject) {
    let mimicAS = MimicActionSheet(actionSheetDelegate: self, title:"更换背景图片", cancelButtonTitle: nil, otherButtonTitles: "拍一张","从手机相册选择")
        mimicAS.show()
    }
    
    func didClickButtonAtIndex(index: Int,actionSheet:MimicActionSheet) {
        if index == 0
        {
            print("Camera")
        }
        else
        {
            let albumsVC = AlbumsTableViewController()
            NSUserDefaults.standardUserDefaults().setObject(albumsVC.allowMultipleSelection, forKey: "multi_key")
            NSUserDefaults.standardUserDefaults().synchronize()
            let customNav = MyNavigationController(rootViewController: albumsVC)
            presentViewController(customNav, animated: true, completion: nil)
        }
        actionSheet.dismiss()
    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

