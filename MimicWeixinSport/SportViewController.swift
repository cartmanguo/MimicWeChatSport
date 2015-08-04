//
//  ViewController.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/3.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit

class SportViewController : UIViewController,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    var friendsRankContainer: UIView!
    var numberOfData:Int = 9
    let cellHeight:CGFloat = 60
    var threshold:CGFloat?
    var userDatas:[UserData]?
    @IBOutlet weak var championView: UIView!
    @IBOutlet weak var championNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        userDatas?.sort({(s1:UserData,s2:UserData)->Bool in
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
        for var i = 0;i<numberOfData;i++
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
            friendView.layer.borderWidth = 0.3
            friendView.layer.borderColor = UIColor.lightGrayColor().CGColor
            let frame = CGRectMake(-1, cellHeight*CGFloat(i)-1, friendsRankContainer.frame.size.width+2, cellHeight)
            let fd = friendView
            fd.rankLabel.text = String(format: "%d", i+1)
            fd.frame = frame
            friendsRankContainer.addSubview(fd)
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func toPersonDetail(tap:UIGestureRecognizer)
    {
        let friendView = tap.view as! FriendView
        let userData = friendView.userData
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Person") as! PersonDetailViewController
        detailVC.userData = userData
        navigationController?.pushViewController(detailVC, animated: true)
    }
    @IBAction func reset(sender: AnyObject) {
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as! UITableViewCell
        cell.textLabel!.text = "Cartman"
        cell.separatorInset = UIEdgeInsetsZero
        cell.preservesSuperviewLayoutMargins = false
        cell.layoutMargins = UIEdgeInsetsZero
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 15
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
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

