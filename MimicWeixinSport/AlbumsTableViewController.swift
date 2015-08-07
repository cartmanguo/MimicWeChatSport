//
//  AlbumsTableViewController.swift
//  MimicWeixinSport
//
//  Created by randy on 15/8/7.
//  Copyright (c) 2015年 randy. All rights reserved.
//

import UIKit
import AssetsLibrary

class AlbumsTableViewController: UITableViewController {
    var albums:[ALAssetsGroup] = []
    let assetLib = ALAssetsLibrary()

    override func viewDidLoad() {
        //self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        self.tableView.tableFooterView = UIView()
        self.title = "照片"
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        let cancelBtn = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Plain, target: self, action: "close")
        self.navigationItem.rightBarButtonItem = cancelBtn
        super.viewDidLoad()
        loadAlbums({(allAlbums) in
        })
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func close()
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadAlbums(completionHandler:(albums:[ALAssetsGroup])->())
    {
        var allAlbums = [ALAssetsGroup]()
        assetLib.enumerateGroupsWithTypes(ALAssetsGroupAll, usingBlock: {(group,pointer) in
            if let assetGroup = group
            {
                self.albums.append(assetGroup)
                self.tableView.reloadData()
                //println("\(assetGroup.valueForProperty(ALAssetsGroupPropertyName) as! String)")
            }
            }, failureBlock: {(err) in
                println("\(err.localizedDescription)")
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return albums.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        if cell == nil
        {
            cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        }
        // Configure the cell...
        let assetGroup = albums[indexPath.row]
        let assetName = assetGroup.valueForProperty(ALAssetsGroupPropertyName) as! String
        cell!.textLabel?.text = assetName
        cell!.detailTextLabel?.text = "\(assetGroup.numberOfAssets())"
        assetGroup.posterImage()
        //if use takeRetainedValue(),app will crush somehow,why?
        cell!.imageView?.image = UIImage(CGImage: assetGroup.posterImage().takeUnretainedValue())
        return cell!
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
